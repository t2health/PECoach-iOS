//
//  SecuritySettingsActionViewController.m
//  PECoach
//

#import "SecuritySettingsActionViewController.h"
#import "PECoachConstants.h"
#import "StartupManager.h"
#import "Analytics.h"

@implementation SecuritySettingsActionViewController

#pragma mark - Properties

@synthesize startupManager = startupManager_;
@synthesize PINTextField = PINTextField_;
@synthesize primaryQuestionTextField = primaryQuestionTextField_;
@synthesize primaryAnswerTextField = primaryAnswerTextField_;
@synthesize secondaryQuestionTextField = secondaryQuestionTextField_;
@synthesize secondaryAnswerTextField = secondaryAnswerTextField_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action
 */
- (id)initWithSession:(Session *)session action:(Action *)action {
  self = [super initWithSession:session action:action];
  if (self != nil) {
    startupManager_ = [[StartupManager alloc] init];
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  __block CGFloat yOrigin = kUIViewVerticalInset;
  NSArray *labels = [NSArray arrayWithObjects:NSLocalizedString(@"PIN:", @""),
                                              NSLocalizedString(@"Question 1:", @""), 
                                              NSLocalizedString(@"Answer 1:", @""),
                                              NSLocalizedString(@"Question 2:", @""), 
                                              NSLocalizedString(@"Answer 2:", @""), nil];
  
  // Layout the labels and text fields. Note that for the first row "PIN", we layout the text field
  // to the right of the label. For all other fields we layout the text field below the label.
  [labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    BOOL isPINRow = (idx == 0);
    CGFloat fieldWidth = (isPINRow == YES ? 40.0 : self.formScrollView.frame.size.width - (kUIViewHorizontalInset * 2));
    CGFloat xOrigin = kUIViewHorizontalInset;

    UILabel *label = [self formLabelWithFrame:CGRectMake(xOrigin, yOrigin, fieldWidth, kUITextFieldDefaultHeight) text:obj];
      label.textColor = [UIColor whiteColor];
      
    [self.formScrollView addSubview:label];

    if (isPINRow == YES) {
      xOrigin += fieldWidth;
      fieldWidth = 100.0;
    } else {
      yOrigin += (kUITextFieldDefaultHeight - 5.0);
    }
    
    UITextField *textField = [self formTextFieldWithFrame:CGRectMake(xOrigin, yOrigin, fieldWidth, kUITextFieldDefaultHeight) text:nil];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;  
    textField.secureTextEntry = (isPINRow == YES);
    
    [self.formScrollView addSubview:textField];
        
    switch (idx) {
      case 0: {
        textField.text = self.startupManager.PIN;
        self.PINTextField = textField;
        break;
      }
        
      case 1: {
        textField.text = self.startupManager.primarySecretQuestion;
        self.primaryQuestionTextField = textField;
        break;
      }

      case 2: {
        textField.text = self.startupManager.primarySecretAnswer;
        self.primaryAnswerTextField = textField;
        break;
      }

      case 3: {
        textField.text = self.startupManager.secondarySecretQuestion;
        self.secondaryQuestionTextField = textField;
        break;
      }

      case 4: {
        textField.text = self.startupManager.secondarySecretAnswer;
        self.secondaryAnswerTextField = textField;
        break;
      }
    }

    yOrigin += kUITextFieldDefaultHeight;
  }];
  
  self.saveButton.enabled = [self areAllTextFieldsPopulated];
  [self resizeContentViewToFitForScrollView:self.formScrollView];
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.PINTextField = nil;
  self.primaryQuestionTextField = nil;
  self.primaryAnswerTextField = nil;
  self.secondaryQuestionTextField = nil;
  self.secondaryAnswerTextField = nil;
  
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"SECURITY SETTINGS ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [startupManager_ release];
  
  [PINTextField_ release];
  [primaryQuestionTextField_ release];
  [primaryAnswerTextField_ release];
  [secondaryQuestionTextField_ release];
  [secondaryAnswerTextField_ release];
  
  [super dealloc];
}

#pragma mark - UI Actions

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  self.startupManager.PIN = self.PINTextField.text;
  self.startupManager.primarySecretQuestion = self.primaryQuestionTextField.text;
  self.startupManager.primarySecretAnswer = self.primaryAnswerTextField.text;
  self.startupManager.secondarySecretQuestion = self.secondaryQuestionTextField.text;
  self.startupManager.secondarySecretAnswer = self.secondaryAnswerTextField.text;
  
  [self.startupManager save];
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIKeyboard Notification Methods

/**
 *  handleKeyboardWillHideNotification
 */
- (void)handleKeyboardWillHideNotification:(NSNotification*)notification {
  // We can kind of cheat here and only update the state of the Save button
  // when the keyboard is dismissed because the Save button is always hidden
  // while the keyboard is visible. 
   self.saveButton.enabled = [self areAllTextFieldsPopulated];
}

#pragma mark - Instance Methods

/**
 *  areAllTextFieldsPopulated
 */
- (BOOL)areAllTextFieldsPopulated {
  // Note that this doesn't include the PIN field per Issue #94.
  NSArray *textFields = [NSArray arrayWithObjects:self.primaryQuestionTextField,
                                                  self.primaryAnswerTextField,
                                                  self.secondaryQuestionTextField,
                                                  self.secondaryAnswerTextField, nil];
  __block BOOL allFieldsPopulated = YES;
  
  [textFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    UITextField *textField = (UITextField *)obj;
    allFieldsPopulated = [textField.text length] > 0;
    *stop = !allFieldsPopulated;
  }];
  
  return allFieldsPopulated;
  
}

@end
