//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// 1.  The permission granted herein does not extend to commercial use of
// the Software by entities primarily engaged in providing online video
// and related services; and
// 
// 2.  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@class BCEmailViewController;
@class BCVideo;

extern CGFloat const BC_SHARING_VIEW_WIDTH;
extern CGFloat const BC_SHARING_VIEW_HEIGHT;

@protocol BCSharingViewDelegate <NSObject>

/**
 When this method is called the BCSharingViewController wants to be closed. It is
 your job to remove it from your UIView and release it.
 */ 
- (void)closeSharingView;

/**
 When the in app email view is going to be displayed it needs a view to be presented
 modally from. Return the UIViewController you want the email view to be presented in.
 */
- (UIViewController *)viewControllerToPresentEmailCompose;

/**
 This lets you customize how the in app email view is preseted. Either with an animation
 return YES or with out an animation return NO.
 */
- (BOOL)shouldAnimateEmailComposePresentation;

@optional
/**
 By default this is set to NO so the in app email view will be displayed. If you implement
 this delegate method and return YES your app will prompt the user to exit your application
 to use the Mail app.
 */
- (BOOL)shouldExitApplicationToSendEmail;

@end


/**
 The BCSharingViewController class provides an easy way to enable your users to email links to your 
 videos and tweet links via twitter. To create an view to allow the user to email a link to your 
 video, you must first create a web accessible player for email sharing on http://my.brightcove.com 
 in your account. Your application will need to know the ID of this player, since the emails will 
 direct users to the sharing player.
 
 During the life cycle of the BCSharingViewController there will be delegate callbacks your code 
 will need to responde to.
 
 - (UIViewController *)viewControllerToPresentEmailCompose : this is called when the sharing view 
 needs a UIViewController to present the in app email ui provided by Apple.
 
 - (void)closeSharingView : when the sharing view is done it will call this method to let your code 
 know it is ready to be removed from your view.
 
 - (BOOL)shouldAnimateEmailComposePresentation : this lets you customize the way the in app email is 
 presented to your users. Returning YES will animate the transition, returning NO will make the 
 email view appear with out an animation.
 
 - (BOOL)shouldExitApplicationToSendEmail : is optional, the sharing view defaults to using in app 
 email. If you want to us the Mail app on iOS you should return YES in this callback.
 
 @code
 // Don't forget to include this line in your source:
 #import "BCSharingViewController.h"
 
 BCSharingViewController *bcsvc = [[BCSharingViewController alloc] init];
 [bcsvc setVideo: self.video];
 [bcsvc setSharingPlayerId: self.playerId];
 [bcsvc setDelegate:self];
 
 [self.view addSubview:bcsvc.view];
 @endcode
 */
@interface BCSharingViewController : UIViewController <UINavigationControllerDelegate> {
    id<BCSharingViewDelegate> delegate;
    UINavigationController *controller;
    BCVideo *video;
    long long sharingPlayerId;
    UIButton *cancel;
}

/**
 @brief An object that conforms to the BCSharingViewDelegate
 
 This object handles callbacks from the BCSharingViewController. It also
 allows the developer to change how the BCSharingViewController behaves.
 */
@property(nonatomic, assign) id<BCSharingViewDelegate> delegate;

/**
 @brief Video for sharing
 
 When sharing videos via email or twitter, a link is composed to a specific player capable
 of rendering that video in a web-based Brightcove player. This BCVideo instance is used in
 that process.
 */
@property(nonatomic, retain) BCVideo *video;

/**
 @brief PlayerId for sharing
 
 When sharing videos via email or twitter, a link is composed to a specific player capable
 of rendering that video in a web-based Brightcove player. This player is identified by
 this property.
 */
@property(nonatomic, assign) long long sharingPlayerId;

@end
