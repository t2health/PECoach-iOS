//
//  ActionViewController.m
//  PECoach
//

#import <AVFoundation/AVFoundation.h>
#import "ActionViewController.h"
#import "Action.h"
#import "Librarian.h"
#import "PECoachAppDelegate.h"
#import "PECoachConstants.h"
#import "Session.h"
#import "SUDSTextField.h"
#import "Visit.h"
#import "MKInfoPanel.h"

@implementation ActionViewController

#pragma mark - Properties

@synthesize infoView = infoView_;
@synthesize infoLabel = infoLabel_;

@synthesize action = action_;
@synthesize session = session_;
@synthesize infoTitle = infoTitle_;
@synthesize defaultTextFont = defaultTextFont_;
@synthesize defaultTableCellFont = defaultTableCellFont_;
@synthesize defaultTextColor = defaultTextColor_;
@synthesize defaultSelectedTextColor = defaultSelectedTextColor_;
@synthesize defaultSolidViewBackgroundColor = defaultSolidViewBackgroundColor_;
@synthesize defaultBorderColor = defaultBorderColor_;
@synthesize showHomeButton = showHomeButton_;
@synthesize showDoneButton = showDoneButton_;
@synthesize didWeShowBackgroundAlert = didWeShowBackgroundAlert_;



#pragma mark - Lifecycle

/**
 *  initWithSession:action
 */
- (id)initWithSession:(Session *)session action:(Action *)action {
  self = [super initWithNibName:@"ActionViewController" bundle:nil];
  if (self != nil) {
    session_ = [session retain];
    action_ = [action retain];
    defaultTextFont_ = [[UIFont systemFontOfSize:13.0] retain];
    defaultTableCellFont_ = [[UIFont boldSystemFontOfSize:14.0] retain];
    defaultTextColor_ = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.25 alpha:1.0];
    defaultSelectedTextColor_ = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.75 alpha:1.0];
    defaultSolidViewBackgroundColor_ = [[UIColor alloc] initWithWhite:0.95 alpha:1.0];
    defaultBorderColor_ = [[UIColor alloc] initWithWhite:0.85 alpha:1.0];
    showHomeButton_ = YES;
    showDoneButton_ = YES;
    didWeShowBackgroundAlert = NO; 
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Handle keyboard show/hide  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    // Handle the App entering the background (recording pauses, ???)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppEnteringBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];

  self.navigationItem.title = self.session.title;

  self.navigationController.navigationBar.tintColor = self.session.color;
  self.infoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"infoBarBackground.png"]]; 
  self.infoLabel.textColor = self.session.subTitleColor;
  self.infoLabel.shadowColor = [UIColor whiteColor];
  self.infoLabel.shadowOffset = CGSizeMake(0.0, 1.0);
  self.infoLabel.text = (self.infoTitle != nil ? self.infoTitle : self.action.title);
  
  // For the main menu screens of each session, we show the "Home" button on the left hand side. If the
  // user drills in to an action, then we also show a "Done" button on the right hand side. However, 
  // if the user drills in to an action from a sub-menu, then we show the "Back" button.
  if (self.showDoneButton == NO && self.showHomeButton == NO) {
    UIBarButtonItem *fakeBackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") 
                                                                          style:UIBarButtonItemStyleBordered 
                                                                         target:self 
                                                                         action:@selector(handleFakeBackButtonTapped:)];
    self.navigationItem.leftBarButtonItem = fakeBackBarButtonItem;
    [fakeBackBarButtonItem release];
  } else {
    if (self.showHomeButton) {
      UIBarButtonItem *homeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Switch Session", @"") 
                                                                            style:UIBarButtonItemStyleBordered 
                                                                           target:self 
                                                                           action:@selector(handleHomeButtonTapped:)];
      self.navigationItem.leftBarButtonItem = homeBarButtonItem;
      [homeBarButtonItem release];
    } 
    
    if (self.showDoneButton) {
      UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") 
                                                                            style:UIBarButtonItemStyleBordered 
                                                                           target:self 
                                                                           action:@selector(handleDoneButtonTapped:)];
      self.navigationItem.rightBarButtonItem = doneBarButtonItem;
      [doneBarButtonItem release];
    }
  }
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

  self.infoLabel = nil;
  self.infoView = nil;
  
  [super viewDidUnload];
}

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    didWeShowBackgroundAlert = NO;
}

/**
 *  viewWillDisappear
 */
- (void)viewWillDisappear:(BOOL)animated {
    // View is going away...that means we are finished with the current action
  if (self.action != nil)  {
    self.action.completed = [NSNumber numberWithBool:YES];
    [self.librarian save];
  }
   
  
  [super viewWillDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:[NSString stringWithFormat:@"ACTION VIEW: %@, SELECTION: %@",self.navigationItem.title, self.infoLabel.text]];
    [super viewDidAppear:animated];
}


/**
 *  dealloc
 */
- (void)dealloc {
  [infoLabel_ release];
  [infoView_ release];
  
  [action_ release];
  [session_ release];
  [infoTitle_ release];
  [defaultTextFont_ release];
  [defaultTableCellFont_ release];
  [defaultTextColor_ release];
  [defaultSelectedTextColor_ release];
  [defaultSolidViewBackgroundColor_ release];
  [defaultBorderColor_ release];
  
  [super dealloc];
}

#pragma mark - UI Actions

/**
 *  handleHomeButtonTapped
 */
- (void)handleHomeButtonTapped:(id)sender {
    
    // Remember that we will 'Go Home' unless the alert is invoked
    BOOL bGoHome = YES;
    
    // Are we recording right now?
    if (self.session.audioRecorder != Nil) {
        if (self.session.audioRecorder.isRecording == YES) {
            
            // Let the user know this action will stop the recording
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Recording in Progress",nil)
                                  message:NSLocalizedString(@"Please return to this session's Recording and stop it before you Switch Sessions.",nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Close", nil) 
                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            bGoHome = NO;       // We have this covered...don't do anything below
        }
    }
    
    // Do we still need to handle the request?
    if (bGoHome) {
        [self stopSessionRecording];
        
        PECoachAppDelegate *appDelegate = (PECoachAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showSessionsMenuViewController];
    }

}

/**
 *  handleDoneButtonTapped
 */
- (void)handleDoneButtonTapped:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  handleFakeBackButtonTapped
 */
- (void)handleFakeBackButtonTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

/*
 NOT used at this time...there is only one button...no decisions to be made!
 
#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Button #1 means they want to continue...see the Alert code above
    if (buttonIndex == 1) {
        [self stopSessionRecording];
        
        PECoachAppDelegate *appDelegate = (PECoachAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showSessionsMenuViewController];
    }
}
 */

#pragma mark - UITextFieldDelegate Methods

/**
 *  textFieldDidBeginEditing
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

/**
 *  textFieldDidEndEditing
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
}

/**
 *  textFieldShouldReturn
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

/**
 *  textField:shouldChangeCharactersInRange
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  if ([textField isKindOfClass:[SUDSTextField class]] == YES) {
    NSString *proposedString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    if ([proposedString length] > 0 && [self isValidSUDSRating:proposedString] == NO) {
      UIAlertView *alertView = [self alertViewForInvalidSUDSRating];
      [alertView show];
      
      return NO;
    }
  }
  
  return YES;
}

#pragma mark - UIKeyboard Notification Methods

/**
 *  handleKeyboardDidShowNotification
 */
- (void)handleKeyboardDidShowNotification:(NSNotification*)notification {
}

/**
 *  handleKeyboardWillHideNotification
 */
- (void)handleKeyboardWillHideNotification:(NSNotification*)notification {
}


#pragma mark - App Entering Background Notification Method

- (void)handleAppEnteringBackground:(NSNotification*)notification { 
    
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
    {
        [app cancelAllLocalNotifications];
    }
    
    // And did we already show this?
    if (didWeShowBackgroundAlert == NO) {  
        // Are we recording right now?
        if (self.session.audioRecorder != Nil) {
            if (self.session.audioRecorder.isRecording == YES) {
                // Create a new notification.
                UILocalNotification* alarm = [[[UILocalNotification alloc] init] autorelease];
                if (alarm)
                {        
                    [Analytics logEvent:@"RECORDING PAUSED WITH APP IN BACKGROUND"];
                    alarm.fireDate = nil;
                    alarm.timeZone = [NSTimeZone defaultTimeZone];
                    alarm.repeatInterval = 0;
                    alarm.soundName = UILocalNotificationDefaultSoundName;  
                    alarm.alertBody = NSLocalizedString(@"The recording is paused!\x0a\x0aRestart the PE Coach App\x0ato continue recording!",nil);
                    
                    [app scheduleLocalNotification:alarm];
                    didWeShowBackgroundAlert = YES;
                }
            }
        }    
    }
    
}

#pragma mark - Instance Methods

/**
 *  contentFrame
 */
- (CGRect)contentFrame {
  // Returns a frame that represents the content area below the info view.
  CGRect frame = self.view.frame;
  frame.size.height -= self.infoView.frame.size.height;
  frame.origin.y += self.infoView.frame.size.height;
    
  return frame;
}


/**
 *  stopSessionRecording
 */
- (void)stopSessionRecording {
  // This method is in this class and not in the RecordActionViewController because we need to be able to 
  // stop the session recording from any action view controller.
  [self.session.audioRecorder stop];
  self.session.audioRecorder = nil;
  [self.librarian save];
    
  // Make sure sleep is allowed again
    [UIApplication sharedApplication].idleTimerDisabled = NO;  
  
  UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:1];
  tabBarItem.badgeValue = nil;
}

/**
 *  isValidSUDSRating
 */
- (BOOL)isValidSUDSRating:(NSString *)ratingString {
  NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
  
  // A SUDS rating must be between 0 and 100
  BOOL isValid = [ratingString integerValue] >= kMinimumSUDSRating && [ratingString integerValue] <= kMaximumSUDSRating;
  
  // Unfortunately, if the user types in something like "4G", [NSString integerValue] will return a value
  // of 4 which passes the test above, but needs to fail for our purposes. So even if the string appears
  // to be a valid number, we still need to check every character.
  for (NSUInteger index = 0; index < [ratingString length] && isValid; index++) {
    unichar character = [ratingString characterAtIndex:index];
    isValid = [numericSet characterIsMember:character];
  }
  
  return isValid;
}

/**
 *  validateSUDSField
 */
- (BOOL)validateSUDSField:(UITextField *)field {
  return [self validateSUDSFields:[NSArray arrayWithObject:field]];
}

/**
 *  validateSUDSFields
 */
- (BOOL)validateSUDSFields:(NSArray *)fields {
  __block BOOL validFields = YES;
  
  [fields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    UITextField *textField = (UITextField *)obj;
    validFields = [self isValidSUDSRating:textField.text];
    *stop = (validFields == NO);
  }];
  
  return validFields;
}

/**
 *  alertViewForInvalidSUDSRating
 */
- (UIAlertView *)alertViewForInvalidSUDSRating {
  NSString *alertTitle = NSLocalizedString(@"Alert", @"");
  NSString *alertMessage = NSLocalizedString(@"All SUDS ratings need to be between 0 and 100.", @"");
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                  message:alertMessage 
                                                 delegate:nil 
                                        cancelButtonTitle:NSLocalizedString(@"Continue", @"") 
                                        otherButtonTitles:nil];
  return [alert autorelease];
}

/**
 *  resizeContentViewToFitForScrollView
 */
- (void)resizeContentViewToFitForScrollView:(UIScrollView *)scrollView {
  __block CGFloat height = 0.0;
  
  [scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    // Hmm, bit of a dangerous hack here but a UIScrollView has two hidden subviews that
    // represent the horizontal and vertical scrollbars. We don't want to consider their
    // height when calculating the optimal content height. Naturally, this will break
    // this method if a UIImageView happens to be the last legitimate child.
    UIView *view = (UIView *)obj;
    if ([view isKindOfClass:[UIImageView class]] == NO) {
      height = MAX(height, (view.frame.origin.y + view.frame.size.height));
    }
  }];
  
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, height);
}

/**
 *  buttonWithTitle
 */
- (UIButton *)buttonWithTitle:(NSString *)title { 
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
  button.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
  
  NSString *buttonBackgroundNormalName = @"buttonBackgroundNormalLarge.png";
  NSString *buttonBackgroundHighlightedName = @"buttonBackgroundHighlightedLarge.png";
  CGFloat buttonWidth = kUIButtonSizeLargeWidth;
  
  CGSize titleSize = [title sizeWithFont:button.titleLabel.font];
  if (titleSize.width > kUIButtonSizeSmallWidth && titleSize.width < kUIButtonSizeMediumWidth) {
    buttonBackgroundNormalName = @"buttonBackgroundNormalMedium.png";
    buttonBackgroundHighlightedName = @"buttonBackgroundHighlightedMedium.png";
    buttonWidth = kUIButtonSizeMediumWidth;
  } else if (titleSize.width < kUIButtonSizeSmallWidth) {
    buttonBackgroundNormalName = @"buttonBackgroundNormalSmall.png";
    buttonBackgroundHighlightedName = @"buttonBackgroundHighlightedSmall.png";
    buttonWidth = kUIButtonSizeSmallWidth;
  }

  [button setBackgroundImage:[UIImage imageNamed:buttonBackgroundNormalName] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:buttonBackgroundHighlightedName] forState:UIControlStateHighlighted];
  [button setTitle:title forState:UIControlStateNormal];
  
  [button setTitleColor:[UIColor colorWithRed:28.0/255.0 green:39.0/255.0 blue:57.0/255.0 alpha:1.0] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  
  [button setTitleShadowColor:[UIColor colorWithWhite:0.9 alpha:1.0] forState:UIControlStateNormal];
  [button setTitleShadowColor:[UIColor colorWithWhite:0.3 alpha:1.0] forState:UIControlStateHighlighted];
  
  [button setFrame:CGRectMake(0.0, 0.0, buttonWidth, kUIButtonDefaultHeight)];
  
  return button;
}

/**
 *  formLabelWithFrame:text
 */
- (UILabel *)formLabelWithFrame:(CGRect)frame text:(NSString *)text {
  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.backgroundColor = [UIColor clearColor];
  label.font = self.defaultTableCellFont;
  label.text = text;
  label.textColor = self.defaultTextColor;
  
  return [label autorelease];
}

/**
 *  formTextFieldWithFrame:text
 */
- (UITextField *)formTextFieldWithFrame:(CGRect)frame text:(NSString *)text {
  UITextField *textfield = [[UITextField alloc] initWithFrame:frame];
  textfield.borderStyle = UITextBorderStyleRoundedRect;
  textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  textfield.delegate = self;
  textfield.returnKeyType = UIReturnKeyDone;
  textfield.text = text;
  
  return [textfield autorelease];
}

/**
 *  SUDSTextFieldWithFrame
 */
- (UITextField *)SUDSTextFieldWithFrame:(CGRect)frame text:(NSString *)text {
  SUDSTextField *textfield = [[SUDSTextField alloc] initWithFrame:frame];
  textfield.borderStyle = UITextBorderStyleRoundedRect;
  textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  textfield.delegate = self;
  textfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  textfield.returnKeyType = UIReturnKeyDone;
    textfield.text = text;
    
    
  return textfield;
}

@end

