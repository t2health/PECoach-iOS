//
//  SessionsMenuDelegate.h
//  PECoach
//

#import <Foundation/Foundation.h>

@class Session;
@class SessionsMenuViewController;

@protocol SessionsMenuDelegate <NSObject>

@optional

- (void)sessionsMenuViewController:(SessionsMenuViewController *)viewController didSelectSession:(Session *)session;

@end
