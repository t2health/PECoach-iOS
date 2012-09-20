//
//  LostPINViewController.m
//  PECoach
//

#import "LostPINViewController.h"
#import "PINViewController.h"
#import "StartupManager.h"
#import "Analytics.h"

@implementation LostPINViewController

#pragma mark - Properties

@synthesize primaryLabel = primaryLabel_;
@synthesize primaryTextField = primaryTextField_;
@synthesize secondaryLabel = secondaryLabel_;
@synthesize secondaryTextField = secondaryTextField_;
@synthesize startupManager = startupManager_;

#pragma mark - Lifecycle

/**
 *  initWithStartupManager
 */
- (id)initWithStartupManager:(StartupManager *)manager {
  self = [super initWithNibName:@"LostPINViewController" bundle:nil];
  if (self != nil) {
    startupManager_ = [manager retain];
  }
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = NSLocalizedString(@"Forgot Pin?", @"");

  self.primaryLabel.text = self.startupManager.primarySecretQuestion;
  self.primaryTextField.returnKeyType = UIReturnKeyDone;
  self.primaryTextField.delegate = self;

  self.secondaryLabel.text = self.startupManager.secondarySecretQuestion;
  self.secondaryTextField.returnKeyType = UIReturnKeyDone;
  self.secondaryTextField.delegate = self;
  
  if ([self.startupManager.primarySecretQuestion length] == 0) {
    self.primaryLabel.hidden = YES;
    self.primaryTextField.hidden = YES;
    
    self.secondaryLabel.frame = self.primaryLabel.frame;
    self.secondaryTextField.frame = self.primaryTextField.frame;
  }
  
  if ([self.startupManager.secondarySecretQuestion length] == 0) {
    self.secondaryLabel.hidden = YES;
    self.secondaryTextField.hidden = YES;
  }
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.primaryLabel = nil;
  self.primaryTextField = nil;
  self.secondaryLabel = nil;
  self.secondaryTextField = nil;
  
  [super viewDidUnload];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [primaryLabel_ release];
  [primaryTextField_ release];
  [secondaryLabel_ release];
  [secondaryTextField_ release];
  
  [startupManager_ release];
  
  [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"LOST PIN ACTION VIEW"];
    [super viewDidAppear:animated];
}

#pragma mark - IBActions

/**
 *  handleCancelButtonTapped
 */
- (IBAction)handleCancelButtonTapped:(id)sender {
  [self showPINViewController];
}

/**
 *  handleSubmitButtonTapped
 */
- (IBAction)handleSubmitButtonTapped:(id)sender {
  NSString *recoveredPIN = [self.startupManager recoverPINWithPrimaryAnswer:self.primaryTextField.text secondaryAnswer:self.secondaryTextField.text];
  if (recoveredPIN == nil) {
    NSString *alertTitle = NSLocalizedString(@"Alert", @"");
    NSString *alertMessage = NSLocalizedString(@"Your responses were not completely correct. Please try again.", @"");
    NSString *buttonTitle = NSLocalizedString(@"Continue", @"");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alertView show];
    [alertView release];
  } else {
    NSString *alertTitle = NSLocalizedString(@"Your Pin", @"");
    NSString *message = NSLocalizedString(@"Your responses were correct. Your Pin is", @"");
    NSString *alertMessage = [NSString stringWithFormat:@"%@ %@.", message, recoveredPIN];
    NSString *buttonTitle = NSLocalizedString(@"Continue", @"");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alertView show];
    [alertView release];
  }
}

#pragma mark - Instance Methods

/**
 *  showPINViewController
 */
- (void)showPINViewController {
  PINViewController *viewController = [[PINViewController alloc] initWithStartupManager:self.startupManager];
  [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController]];
  [viewController release];
}

#pragma mark - UIAlertViewDelegate Methods

/**
 *  alertView:clickedButtonAtIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  // The only UIAlertView that has us as a delegate is the alert view we show when the
  // user has successfully recovered their PIN. Since that alert view only has a single
  // "Continue" button, we don't really need to test for much here. 
  [self showPINViewController];
}

#pragma mark - UITextFieldDelegate Methods

/**
 *  textFieldShouldReturn
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.primaryTextField || textField == self.secondaryTextField) {
    [textField resignFirstResponder];
  }
  
  return YES;
}

@end
