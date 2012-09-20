//
//  PINViewController.m
//  PECoach
//

#import "PINViewController.h"
#import "LostPINViewController.h"
#import "StartupManager.h"
#import "WelcomeViewController.h"
#import "Analytics.h"

@implementation PINViewController

#pragma mark - Properties

@synthesize PINTextField = PINTextField_;
@synthesize startupManager = startupManager_;

#pragma mark - Lifecycle

/**
 *  initWithStartupManager
 */
- (id)initWithStartupManager:(StartupManager *)manager {
  self = [super initWithNibName:@"PINViewController" bundle:nil];
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
  
  self.title = NSLocalizedString(@"Sign In to PE Coach", @"");
  self.PINTextField.returnKeyType = UIReturnKeyDone;
  self.PINTextField.delegate = self;
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.PINTextField.delegate = nil;
  self.PINTextField = nil;

  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"PIN VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [PINTextField_ setDelegate:nil];
  [PINTextField_ release];
  [startupManager_ release];
  
  [super dealloc];
}

#pragma mark - IBActions

/**
 *  handleSignInButtonTapped
 */
- (IBAction)handleSignInButtonTapped:(id)sender {
  [self.startupManager authenticateWithPIN:self.PINTextField.text];
  
  if (self.startupManager.isAuthenticated == YES) {
    WelcomeViewController *viewController = [[WelcomeViewController alloc] initWithStartupManager:self.startupManager];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController]];
    [viewController release];
  } else {
    NSString *alertTitle = NSLocalizedString(@"Invalid Pin", @"");
    NSString *alertMessage = NSLocalizedString(@"The Pin you entered is invalid. Please try entering your Pin again.", @"");
    NSString *buttonTitle = NSLocalizedString(@"Continue", @"");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alertView show];
    [alertView release];
  }
}

/**
 *  handleAmnesiaButtonTapped
 */
- (IBAction)handleAmnesiaButtonTapped:(id)sender {
  LostPINViewController *viewController = [[LostPINViewController alloc] initWithStartupManager:self.startupManager];
  [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController]];
  [viewController release];
}

#pragma mark - UITextFieldDelegate Methods

/**
 *  textFieldShouldReturn
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.PINTextField) {
    [textField resignFirstResponder];
  }
  
  return YES;
}

@end
