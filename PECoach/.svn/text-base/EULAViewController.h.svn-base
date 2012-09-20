//
//  EULAViewController.h
//  PECoach
//

#import "BaseViewController.h"

@class StartupManager;

@interface EULAViewController : BaseViewController<UIAlertViewDelegate> {
  IBOutlet UITextView *textView_;
  StartupManager *startupManager_;
}

// Properties
@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) StartupManager *startupManager;

// Initializers
- (id)initWithStartupManager:(StartupManager *)manager;

// IBActions
- (IBAction)handleAcceptedButtonTapped:(id)sender;
- (IBAction)handleDeclinedButtonTapped:(id)sender;

@end
