//
//  PECoachAppDelegate.m
//  PECoach
//
/*
 *
 * PECoach
 *
 * Copyright © 2009-2012 United States Government as represented by
 * the Chief Information Officer of the National Center for Telehealth
 * and Technology. All Rights Reserved.
 *
 * Copyright © 2009-2012 Contributors. All Rights Reserved.
 *
 * THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
 * REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
 * COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
 * AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
 * THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
 * INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
 * REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
 * DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
 * HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
 * RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.
 *
 * Government Agency: The National Center for Telehealth and Technology
 * Government Agency Original Software Designation: PECoach001
 * Government Agency Original Software Title: PECoach
 * User Registration Requested. Please send email
 * with your contact information to: robert.kayl2@us.army.mil
 * Government Agency Point of Contact for Original Software: robert.kayl2@us.army.mil
 *
 */
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "PECoachAppDelegate.h"
#import "Action.h"
#import "ActionGroupViewController.h"
#import "ContentLoader.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "RecordActionViewController.h"
#import "Session.h"
#import "SessionsMenuViewController.h"
#import "StartupManager.h"
#import "UIColor+PEColor.h"
#import "WelcomeViewController.h"
#import "Visual.h"
#import "Reachability.h"

@implementation PECoachAppDelegate

#pragma mark - Properties

@synthesize window = window_;
@synthesize librarian = librarian_;
@synthesize networkStatus;
@synthesize connectionRequired;
//@synthesize watchingVideo = watchingVideo_;
@synthesize doingHomework = doingHomework_;
@synthesize actionHomework = actionHomework_;
@synthesize startVisitDate = startVisitDate_;
@synthesize bcServices;

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}


#pragma mark - Lifecycle

/**
 *  application:didFinishLaunchingWithOptions
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Load all of the data from the XML  
  self.librarian = [self libraryWithContentReloaded:NO];
  [self setupInitialUI];
    
    NSString *reachablityURL = [self getAppSetting:@"URLs" withKey: @"reachablityCheckBC"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    
    hostReach = [[Reachability reachabilityWithHostName: reachablityURL] retain];
	[hostReach startNotifier];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
    
    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifier];  
        
    // Not doing Homework now
    doingHomework = NO; 
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    // Production time! (1/9/2012)
//#ifdef DEBUG
 //  NSString *analyticsKey = [self getAppSetting:@"Analytics" withKey:@"debugKey"];
//#else
   NSString *analyticsKey = [self getAppSetting:@"Analytics" withKey:@"appKey"];
//#endif
    [Analytics init:analyticsKey isEnabled:YES];        // Enable Analytics 
    
  return YES;
}

/**
 *  applicationDidEnterBackground
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
  [self.librarian save];

  [self.window.rootViewController dismissModalViewControllerAnimated:NO];
  [self showStartupViewController];
}

/**
 *  applicationWillTerminate
 */
- (void)applicationWillTerminate:(UIApplication *)application {
  [self.librarian save];
}

/**
 *  dealloc
 */
- (void)dealloc {
    
    [hostReach release];
    [wifiReach release];
    [internetReach release];
    
    
  [window_ release];
  [librarian_ release];
  
  [super dealloc];
}

#pragma mark -
#pragma mark FlurryAnalytics Functions
-(void) FlurryAnalyticsPageView:(NSString *)PageViewed {
	[Analytics logEvent:PageViewed];
	[Analytics countPageView];
}

#pragma mark - SessionsMenuDelegate Methods

/**
 *  sessionsMenuViewController:didSelectSession
 */
- (void)sessionsMenuViewController:(SessionsMenuViewController *)viewController didSelectSession:(Session *)session {
  NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:4];
    
  if ([[session actionsForGroup:kActionGroupTasks] count] > 0) {
    ActionGroupViewController *tasksViewController = [[ActionGroupViewController alloc] initWithSession:session actionGroup:kActionGroupTasks];
    UINavigationController *tasksNavigationController = [[UINavigationController alloc] initWithRootViewController:tasksViewController];
    tasksNavigationController.tabBarItem.title = NSLocalizedString(@"Tasks", @"");
    tasksNavigationController.tabBarItem.image = [UIImage imageNamed:@"tasksTabBarIcon.png"];

    [viewControllers addObject:tasksNavigationController];
    [tasksNavigationController release];
    [tasksViewController release];
  }
  
  RecordActionViewController *recordViewController = [[RecordActionViewController alloc] initWithSession:session action:nil];
  UINavigationController *recordNavigationController = [[UINavigationController alloc] initWithRootViewController:recordViewController];
  recordNavigationController.tabBarItem.title = NSLocalizedString(@"Record", @"");
  recordNavigationController.tabBarItem.image = [UIImage imageNamed:@"recordTabBarIcon.png"];

  [viewControllers addObject:recordNavigationController];
  [recordNavigationController release];
  [recordViewController release];

  if ([[session actionsForGroup:kActionGroupToolbox] count] > 0) {
    ActionGroupViewController *toolboxViewController = [[ActionGroupViewController alloc] initWithSession:session actionGroup:kActionGroupToolbox];
    UINavigationController *toolboxNavigationController = [[UINavigationController alloc] initWithRootViewController:toolboxViewController];
    toolboxNavigationController.tabBarItem.title = NSLocalizedString(@"Toolbox", @"");
    toolboxNavigationController.tabBarItem.image = [UIImage imageNamed:@"toolboxTabBarIcon.png"];

    [viewControllers addObject:toolboxNavigationController];
    [toolboxNavigationController release];
    [toolboxViewController release];
  }
  
  if ([[session actionsForGroup:kActionGroupHomework] count] > 0) {
    ActionGroupViewController *homeworkViewController = [[ActionGroupViewController alloc] initWithSession:session actionGroup:kActionGroupHomework];
    UINavigationController *homeworkNavigationController = [[UINavigationController alloc] initWithRootViewController:homeworkViewController];
    homeworkNavigationController.tabBarItem.title = NSLocalizedString(@"Homework", @"");
    homeworkNavigationController.tabBarItem.image = [UIImage imageNamed:@"homeworkTabBarIcon.png"];

    [viewControllers addObject:homeworkNavigationController];
    [homeworkNavigationController release];
    [homeworkViewController release];
  }
  
  UITabBarController *tabBarController = [[UITabBarController alloc] init];
  tabBarController.viewControllers = viewControllers;
    tabBarController.delegate = self;
    
  self.window.rootViewController = tabBarController;
  [tabBarController release];
}



#pragma mark -
#pragma mark Utilities
-(NSString *)getAppSetting:(NSString *)group withKey:(NSString *)key {
    NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app" ofType:@"plist"]] 
                                                        mutabilityOption:NSPropertyListImmutable 
                                                                  format:nil errorDescription:nil];
    NSDictionary *grp = (NSDictionary *)[ps objectForKey:group];
    return (NSString *)[grp objectForKey:key];
}

#pragma mark - Instance Methods

/**
 *  setupInitialUI
 */
- (void)setupInitialUI {
  [self showSessionsMenuViewController];
  [self.window makeKeyAndVisible];
  
  [self setupAudioSession];
  [self showStartupViewController];
}

/**
 *  libraryWithContentReloaded
 */
- (Librarian *)libraryWithContentReloaded:(BOOL)reloadContent {
  Librarian *librarian = [[Librarian alloc] init];
 
  if (reloadContent == YES) {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kUserDefaultsKeyContentVersion];
    [userDefaults synchronize];
  }
  
  ContentLoader *loader = [[ContentLoader alloc] initWithLibrarian:librarian];
  [loader loadContent];
  [loader release];

  return [librarian autorelease];
}

/**
 *  setupAudioSession
 */
- (BOOL)setupAudioSession {
  NSError *setupError = nil;
  
  if ([[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&setupError] == NO) {
    [self audioSessionSetupDidFailWithError:setupError];
    return NO;
  }
  
  if ([[AVAudioSession sharedInstance] setActive:YES error:&setupError] == NO) {
    [self audioSessionSetupDidFailWithError:setupError];
    return NO;
  }
    
  // Override so that Voice Over always uses the speaker phone
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                             sizeof(doChangeDefaultRoute),
                             &doChangeDefaultRoute
                             );
  
  return YES;
}

/**
 *  audioSessionSetupDidFailWithError
 */
- (void)audioSessionSetupDidFailWithError:(NSError *)error {
  NSString *alertTitle = NSLocalizedString(@"Audio Error", @"");
  NSString *alertMessage = [error localizedDescription];
  // tbd TEMP to get the real error.   NSString *alertMessage = NSLocalizedString(@"Recording or playback operations are likely not supported on this device.", @"");
  NSString *cancelTitle = NSLocalizedString(@"Ok", @"");
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil];
  [alertView show];
  [alertView release];
}

/**
 *  showSessionsMenuViewController
 */
- (void)showSessionsMenuViewController {
  SessionsMenuViewController *sessionsMenuViewController = [[SessionsMenuViewController alloc] initWithLibrarian:self.librarian];
  sessionsMenuViewController.delegate = self;
  
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sessionsMenuViewController];
  navigationController.navigationBar.tintColor = [UIColor applicationColor];

  self.window.rootViewController = navigationController;

  [navigationController release];
  [sessionsMenuViewController release];
}

/**
 *  showStartupViewController
 */
- (void)showStartupViewController {
  StartupManager *startupManager = [[StartupManager alloc] init];
  WelcomeViewController *welcomeView = [[WelcomeViewController alloc] initWithStartupManager:startupManager];
  UINavigationController *startupNavigationController = [[UINavigationController alloc] initWithRootViewController:welcomeView];
  startupNavigationController.navigationBar.tintColor = [UIColor applicationColor];
  
  [self.window.rootViewController presentModalViewController:startupNavigationController animated:NO];
  
  [startupNavigationController release];
  [welcomeView release];
  [startupManager release];
}

/**
 *  resetUserData
 */
- (void)resetUserData {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
  dispatch_async(queue, ^{
    // Clear out the user data.
    self.librarian = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *applicationDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSError *error = nil;
    for (NSString *filename in [fileManager contentsOfDirectoryAtPath:applicationDocumentsPath error:&error]) {
      [fileManager removeItemAtPath:[applicationDocumentsPath stringByAppendingPathComponent:filename] error:&error];
    }  
    
    [fileManager release];
    
    // Reset the user defaults
    StartupManager *startupManager = [[StartupManager alloc] init];
    [startupManager reset];
    [startupManager release];
    
    // Reset the loaded content version
    self.librarian = [self libraryWithContentReloaded:YES];

    // Switch back to the main thread for updating the UI.
    dispatch_sync(dispatch_get_main_queue(), ^{
      // Tear down the UI
      [self.window.rootViewController dismissModalViewControllerAnimated:NO];
      self.window.rootViewController = nil;      
      
      // Recreate the library and restore the initial UI.
      [self setupInitialUI];
      
      NSString *alertTitle = NSLocalizedString(@"User Data Cleared", nil);
      NSString *alertMessage = NSLocalizedString(@"All user-entered data, including audio recordings, has been cleared.", nil);
      
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                          message:alertMessage 
                                                         delegate:nil 
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                otherButtonTitles:nil];
      [alertView show];
      [alertView release];
    });
  });
}


#pragma mark -
#pragma mark Checking Internet Connection
-(BOOL)checkInternet{
    NSString *reachablityURL = [self getAppSetting:@"URLs" withKey:@"reachablityCheckBC"];
	Reachability *r = [Reachability reachabilityWithHostName:reachablityURL];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if(internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN) {
		internet = YES;
	}else {
		internet = NO;
	}
	return internet;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach {
    if(curReach == hostReach) {
        self.networkStatus = [curReach currentReachabilityStatus];
        self.connectionRequired= [curReach connectionRequired];
        if (self.networkStatus == NotReachable) {
            self.connectionRequired = NO;
        }
    }
    if (!self.bcServices) {
        BOOL hasInternet = NO;
        switch (self.networkStatus) {
            case NotReachable:
                hasInternet = NO;
                break;
            default:
                if (!self.connectionRequired) {
                    hasInternet = YES;
                }
                break;
        }
        [self checkBCConnection];
    }
}


- (void)checkBCConnection {
    // init Brightcove Media API
    NSString *apiKey = [self getAppSetting:@"Brightcove" withKey:@"apikey"];
    BCMediaAPI *bcServ = [[[BCMediaAPI alloc] initWithReadToken:apiKey] retain];
    [bcServ setMediaDeliveryType:BCMediaDeliveryTypeHTTP];

    bcServices = bcServ;
    [bcServ release];
}

#pragma mark Tab Bar Controller  Delegate methods
- (BOOL)tabBarController:(UITabBarController *)tabBarController 
shouldSelectViewController:(UIViewController *)viewController {
    // Don't allow Homework if a recording is in progress   
    // If we are recording, then there will be a badge on tab bar item #1
    
    /*
    UITabBarItem *tabBarItem = [tabBarController.tabBar.items objectAtIndex:1];
    //UIViewController *recordViewController = [tabBarController.viewControllers objectAtIndex:1];
    if (tabBarItem.badgeValue != Nil) {
        if (viewController == [tabBarController.viewControllers objectAtIndex:3]) 
        {
            // Disable it
            return NO;
        }
     
    }
    */
    // 10/28/2011 Allow everything for now until we figure out if this is necessary
    return YES;
}

#pragma mark Become Resign Active
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


@end
