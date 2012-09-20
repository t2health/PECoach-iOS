//
//  LostPINViewController.h
//  PECoach
//

#import "BaseViewController.h"

@class StartupManager;

@interface LostPINViewController : BaseViewController<UIAlertViewDelegate, UITextFieldDelegate> {
  UILabel *primaryLabel_;
  UITextField *primaryTextField_;
  UILabel *secondaryLabel_;
  UITextField *secondaryTextField_;
  StartupManager *startupManager_;
}

// Properties
@property(nonatomic, retain) IBOutlet UILabel *primaryLabel;
@property(nonatomic, retain) IBOutlet UITextField *primaryTextField;
@property(nonatomic, retain) IBOutlet UILabel *secondaryLabel;
@property(nonatomic, retain) IBOutlet UITextField *secondaryTextField;
@property(nonatomic, retain) StartupManager *startupManager;

// Initializers
- (id)initWithStartupManager:(StartupManager *)manager;

// IBActions
- (IBAction)handleCancelButtonTapped:(id)sender;
- (IBAction)handleSubmitButtonTapped:(id)sender;

// Instance Methods
- (void)showPINViewController;

@end
