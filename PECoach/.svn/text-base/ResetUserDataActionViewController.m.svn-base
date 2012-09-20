//
//  ResetUserDataActionViewController.m
//  PECoach
//

#import "ResetUserDataActionViewController.h"
#import "PECoachAppDelegate.h"
#import "PECoachConstants.h"
#import "UIView+Positionable.h"

@implementation ResetUserDataActionViewController

#pragma mark - Properties

@synthesize confirmationLabel = confirmationLabel_;
@synthesize clearDataButton = clearDataButton_;

#pragma mark - Lifecycle

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = self.defaultSolidViewBackgroundColor;
  
  CGRect labelFrame = CGRectMake(0, kUIViewVerticalInset, self.view.frame.size.width - (kUIViewHorizontalInset * 2), self.defaultTextFont.lineHeight * 3);
  UILabel *label = [self formLabelWithFrame:labelFrame text:NSLocalizedString(@"Would you like to clear all user-entered\
                                                                              data including audio recordings?", nil)];
  label.numberOfLines = 3;
  label.font = self.defaultTextFont;
    label.textColor = [UIColor whiteColor];
  
  [label centerHorizontallyInView:self.formScrollView];
  [self.formScrollView addSubview:label];
  self.confirmationLabel = label;

  UIButton *clearDataButton = [self buttonWithTitle:NSLocalizedString(@"Clear Data", nil)];
  [clearDataButton addTarget:self action:@selector(handleClearButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  [clearDataButton centerHorizontallyInView:self.formScrollView];
  [clearDataButton positionBelowView:self.confirmationLabel margin:(kUIViewVerticalMargin * 3)];

  [self.formScrollView addSubview:clearDataButton];
  self.clearDataButton = clearDataButton;
  
  self.saveButton.hidden = YES;
  [self resizeContentViewToFitForScrollView:self.formScrollView];
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.confirmationLabel = nil;
  self.clearDataButton = nil;
  
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"RESET USER DATA ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [confirmationLabel_ release];
  [clearDataButton_ release];
  
  [super dealloc];
}

#pragma mark - UI Actions

/**
 *  handleClearButtonTapped
 */
- (void)handleClearButtonTapped:(id)sender {
    
    // Double check to make sure this is what the user wants to do!
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Clear All User-Entered Data",nil)
                          message:NSLocalizedString(@"The action you selected will clear all user-entered data including audio recordings.  \n\nPress 'Continue' to clear all user-entered data.  \n\nPress 'Cancel' to keep this data.\n\n",nil)
                          delegate:self 
                          cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                          otherButtonTitles:NSLocalizedString(@"Continue",nil), nil];
    [alert show];
    [alert release];
}


#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Button #1 means they want to continue...see the Alert code above
    if (buttonIndex == 1) {
        [self stopSessionRecording];
        self.clearDataButton.enabled = NO;
        self.confirmationLabel.text = NSLocalizedString(@"Clearing user-entered data...", nil);
        
        UIView *overlay = [[UIView alloc] initWithFrame:[self contentFrame]];
        overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [activityView centerVerticallyInView:overlay];
        [activityView centerHorizontallyInView:overlay];
        
        [overlay addSubview:activityView];
        [activityView startAnimating];
        [activityView release];
        
        [self.view addSubview:overlay];
        [overlay release];
        
        PECoachAppDelegate *appDelegate = (PECoachAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate resetUserData];
    }
}


@end
