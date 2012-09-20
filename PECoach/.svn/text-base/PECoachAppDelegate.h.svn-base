//
//  PECoachAppDelegate.h
//  PECoach
//

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
