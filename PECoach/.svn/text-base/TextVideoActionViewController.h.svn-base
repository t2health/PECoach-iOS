//
//  TextVideoActionViewController.h
//  PECoach
//
//

#import "ActionViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ViewBCVideoController.h"

@class TextVideoAction;
@class Librarian;

@interface TextVideoActionViewController : ActionViewController  
                    <MFMailComposeViewControllerDelegate, ViewBCDelegate> {
  UIButton *videoButton_;
  UITextView *textView_;
  UILabel *urlLabel_;
    UIButton *urlButton_;
}

// Propertiers
@property(nonatomic, retain) UIButton *videoButton;
@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, retain) UILabel *urlLabel;
@property(nonatomic, retain) UIButton *urlButton;

// UI Actions
- (void)handleVideoButtonTapped:(id)sender;
- (void)handleUrlButtonTapped:(id)sender;
- (void)handleSegmentedControlTapped:(id)sender;

// Email methods
-(void)displayComposerSheet;

@end
