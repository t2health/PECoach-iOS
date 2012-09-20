//
//  EULAViewController.m
//  PECoach
//

#import "EULAViewController.h"
#import "IntroductionViewController.h"
#import "StartupManager.h"
#import "Analytics.h"

@implementation EULAViewController

#pragma mark - Properties

@synthesize textView = textView_;
@synthesize startupManager = startupManager_;

#pragma mark - Lifecycle

/**
 *  initWithStartupManager
 */
- (id)initWithStartupManager:(StartupManager *)manager {
  self = [super initWithNibName:@"EULAViewController" bundle:nil];
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
  
  self.title = NSLocalizedString(@"Software License Agreement", @"");

  NSStringEncoding encoding;
  NSError *error;
  NSString *EULAPath = [[NSBundle mainBundle] pathForResource:@"EULA" ofType:@"txt"];  
  NSString *EULAText = [NSString stringWithContentsOfFile:EULAPath usedEncoding:&encoding error:&error];

  self.textView.text = EULAText;
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.textView = nil;
  
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"EULA VIEW"];
    [super viewDidAppear:animated];
}
/**
 *  dealloc
 */
- (void)dealloc {
  [textView_ release];
  [startupManager_ release];

  [super dealloc];
}

#pragma mark - IBActions

/**
 *  handleAcceptedButtonTapped
 */
- (IBAction)handleAcceptedButtonTapped:(id)sender {
    [Analytics logEvent:@"EULA ACCEPTED"];
  self.startupManager.agreedToEULA = YES;
  
  IntroductionViewController *viewcontroller = [[IntroductionViewController alloc] initWithStartupManager:self.startupManager];
  [self.navigationController setViewControllers:[NSArray arrayWithObject:viewcontroller]];
  [viewcontroller release];
}

/**
 *  handleDeclinedButtonTapped
 */
- (IBAction)handleDeclinedButtonTapped:(id)sender {
  NSString *alertTitle = NSLocalizedString(@"Quit PE Coach App?", @"");
  NSString *alertMessage = NSLocalizedString(@"Are you sure you want to quit PE Coach Application?", @"");
  NSString *okTitle = NSLocalizedString(@"YES", @"");
  NSString *cancelTitle = NSLocalizedString(@"NO", @"");
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                      message:alertMessage 
                                                     delegate:self 
                                            cancelButtonTitle:cancelTitle 
                                            otherButtonTitles:okTitle, nil];
  [alertView show];
  [alertView release];

}

#pragma mark - UIAlertViewDelegate Methods

/**
 *  alertView:clickedButtonAtIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  // buttonIndex 0 is the Cancel button. buttonIndex 1 is the "Yes" button.
  if (buttonIndex == 1) {
    // Quit the application. Note that per Apple's own documentation, we aren't supposed to quit. 
    // http://developer.apple.com/library/ios/#qa/qa1561/_index.html
    
      [Analytics logEvent:@"EULA DECLINED"];
      
    // Exiting the main thread will quit the app, but it might cause App Store rejection.
    exit(0);
  }
}

@end
