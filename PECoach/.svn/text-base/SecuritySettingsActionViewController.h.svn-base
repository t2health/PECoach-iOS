//
//  SecuritySettingsActionViewController.h
//  PECoach
//

#import "FormActionViewController.h"

@class StartupManager;

@interface SecuritySettingsActionViewController : FormActionViewController {
  StartupManager *startupManager_;
  UITextField *PINTextField_;
  UITextField *primaryQuestionTextField_;
  UITextField *primaryAnswerTextField_;
  UITextField *secondaryQuestionTextField_;
  UITextField *secondaryAnswerTextField_;
}

// Properties
@property(nonatomic, retain) StartupManager *startupManager;
@property(nonatomic, retain) IBOutlet UITextField *PINTextField;
@property(nonatomic, retain) IBOutlet UITextField *primaryQuestionTextField;
@property(nonatomic, retain) IBOutlet UITextField *primaryAnswerTextField;
@property(nonatomic, retain) IBOutlet UITextField *secondaryQuestionTextField;
@property(nonatomic, retain) IBOutlet UITextField *secondaryAnswerTextField;

// Initializers
- (id)initWithSession:(Session *)session action:(Action *)action;

// Instance Methods
- (BOOL)areAllTextFieldsPopulated;

@end
