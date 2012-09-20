//
//  IntroductionViewController.m
//  PECoach
//

#import "IntroductionViewController.h"
#import "StartupManager.h"
#import "Analytics.h"

@implementation IntroductionViewController

#pragma mark - Properties

@synthesize startupManager = startupManager_;
@synthesize introductionLogo;

#pragma mark - Lifecycle

/**
 *  initWithStartupManager
 */
- (id)initWithStartupManager:(StartupManager *)manager {
  self = [super initWithNibName:@"IntroductionViewController" bundle:nil];
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
  
    self.title = NSLocalizedString(@"An Introduction", @"");
    
    // Set Accessibility for the logo image
    [introductionLogo setIsAccessibilityElement:YES];
    [introductionLogo setAccessibilityTraits:UIAccessibilityTraitImage];
    [introductionLogo setAccessibilityLabel:NSLocalizedString(@"PE Coach Prolonged Exposure Therapy", "")];
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
    [introductionLogo release];
    introductionLogo = nil;
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"INTRODUCTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [startupManager_ release];
  
    [introductionLogo release];
  [super dealloc];
}

#pragma mark - IBActions

/**
 *  handleNextButtonTapped
 */
- (IBAction)handleNextButtonTapped:(id)sender {
  self.startupManager.seenIntroduction = YES;
  [self.startupManager save];
  
  [self.navigationController dismissModalViewControllerAnimated:NO];
}

@end
