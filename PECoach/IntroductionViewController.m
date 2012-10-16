//
//  IntroductionViewController.m
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
