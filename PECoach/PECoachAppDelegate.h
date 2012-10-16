//
//  PECoachAppDelegate.h
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
#import <UIKit/UIKit.h>
#import "Analytics.h"

#import "SessionsMenuDelegate.h"
#import "Reachability.h"
#import "BCMediaAPI.h"

@class Librarian;
@class Action;

@interface PECoachAppDelegate : NSObject <SessionsMenuDelegate, 
                                            UIApplicationDelegate, 
                                                UITabBarControllerDelegate,
                                                    UIAlertViewDelegate> {
  UIWindow *window_;
  UIViewController *currentViewController_;
    Librarian *librarian_;
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
    NetworkStatus networkStatus;
    BOOL connectionRequired;
    //BOOL watchingVideo; 
    BOOL doingHomework; 
    Action *actionHomework;
    NSDate *startVisitDate_;
	BCMediaAPI *bcServices;
}

// Properties
@property(nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) Librarian *librarian;
@property (nonatomic) BOOL connectionRequired;
//@property(nonatomic, assign) BOOL watchingVideo;
@property(nonatomic, assign) BOOL doingHomework;
@property(nonatomic, retain) Action *actionHomework;
@property(nonatomic, retain) NSDate *startVisitDate;
@property (nonatomic) NetworkStatus networkStatus;

@property (nonatomic, readonly) BCMediaAPI *bcServices;

// Instance Methods
- (void)setupInitialUI;
- (Librarian *)libraryWithContentReloaded:(BOOL)reloadContent;
- (BOOL)setupAudioSession;
- (void)audioSessionSetupDidFailWithError:(NSError *)error;
- (void)showSessionsMenuViewController;
- (void)showStartupViewController;
- (void)resetUserData;

-(void) FlurryAnalyticsPageView:(NSString *)PageViewed;

-(BOOL)checkInternet;
-(void)reachabilityChanged:(NSNotification* )note;
-(void)updateInterfaceWithReachability:(Reachability*)curReach;

-(NSString *)getAppSetting:(NSString *)group withKey:(NSString *)key;

- (void)checkBCConnection;
@end
