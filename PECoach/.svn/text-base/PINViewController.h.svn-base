//
//  PINViewController.h
//  PECoach
//

#import "BaseViewController.h"

@class StartupManager;

@interface PINViewController : BaseViewController<UITextFieldDelegate> {
  IBOutlet UITextField *PINTextField_;
  StartupManager *startupManager_;
}

// Properties
@property(nonatomic, retain) IBOutlet UITextField *PINTextField;
@property(nonatomic, retain) StartupManager *startupManager;

// Initializers
- (id)initWithStartupManager:(StartupManager *)manager;

// IBActions
- (IBAction)handleSignInButtonTapped:(id)sender;
- (IBAction)handleAmnesiaButtonTapped:(id)sender;

@end
