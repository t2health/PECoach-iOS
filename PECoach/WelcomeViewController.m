//
//  WelcomeViewController.m
//  PECoach
//

#import "WelcomeViewController.h"
#import "EULAViewController.h"
#import "PINViewController.h"
#import "StartupManager.h"
#import "Analytics.h"

@implementation WelcomeViewController
@synthesize welcomeLogo;

#pragma mark - Properties

@synthesize startupManager = startupManager_;
@synthesize actionButton = actionButton_;

#pragma mark - Lifecycle

/**
 *  initWithStartupManager
 */
- (id)initWithStartupManager:(StartupManager *)manager {
  self = [super initWithNibName:@"WelcomeViewController" bundle:nil];
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

  self.title = NSLocalizedString(@"Welcome", @"");
  [self.title setAccessibilityLabel:NSLocalizedString(@"Welcome, PE Coach Prolonged Exposure Therapy", "")];  
    
    
    // Set Accessibility for the logo image
    [welcomeLogo setIsAccessibilityElement:YES];
    [welcomeLogo setAccessibilityTraits:UIAccessibilityTraitImage];
    [welcomeLogo setAccessibilityLabel:NSLocalizedString(@"PE Coach Prolonged Exposure Therapy", "")];
  
  if (self.startupManager.hasAgreedToEULA == NO || self.startupManager.hasSeenIntroduction == NO) {
    [self.actionButton setTitle:NSLocalizedString(@"Start", @"") forState:UIControlStateNormal];      
  } else {
    if (self.startupManager.isAuthenticated == YES) {
      [self.actionButton setTitle:NSLocalizedString(@"Resume", @"") forState:UIControlStateNormal];      
    } else {
      [self.actionButton setTitle:NSLocalizedString(@"Sign In", @"") forState:UIControlStateNormal];      
    }
  }
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.actionButton = nil;

    [self setWelcomeLogo:nil];
    [welcomeLogo release];
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"WELCOME VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [actionButton_ release];
  [startupManager_ release];

    [welcomeLogo release];
  [super dealloc];
}

#pragma mark - IBActions

/**
 *  handleStartButtonTapped
 */
- (IBAction)handleStartButtonTapped:(id)sender {
  if (self.startupManager.hasAgreedToEULA == NO) {
    // User needs to agree to the EULA before continuing...
    EULAViewController *viewController = [[EULAViewController alloc] initWithStartupManager:self.startupManager];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController]];
    [viewController release];
  } else {
    if (self.startupManager.isAuthenticated == YES) {
      [self.navigationController dismissModalViewControllerAnimated:NO];
    } else {
      PINViewController *viewController = [[PINViewController alloc] initWithStartupManager:self.startupManager];
      [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController]];
      [viewController release];
    }
  }
}

@end
