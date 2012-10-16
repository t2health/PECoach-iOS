//
//  PINViewController.m
//  PECoach
//
/*
 *
 * PECoach
 *
 * Copyright © 2009-2012 United States Government as represented by
 * the Chief Information Officer of the National Center for Telehealth
 * and Technology. All Rights Reserved.
 *
 * Copyright © 2009-2012 Contributors. All Rights Reserved.
 *
 * THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
 * REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
 * COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
 * AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
 * THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
 * INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
 * REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
 * DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
 * HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
 * RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.
 *
 * Government Agency: The National Center for Telehealth and Technology
 * Government Agency Original Software Designation: PECoach001
 * Government Agency Original Software Title: PECoach
 * User Registration Requested. Please send email
 * with your contact information to: robert.kayl2@us.army.mil
 * Government Agency Point of Contact for Original Software: robert.kayl2@us.army.mil
 *
 */
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
