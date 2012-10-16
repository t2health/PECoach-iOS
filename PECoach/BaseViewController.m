//
//  BaseViewController.m
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
#import "BaseViewController.h"
#import "PECoachAppDelegate.h"
#import "Librarian.h"

@implementation BaseViewController

#pragma mark - Properties

@synthesize librarian = librarian_;

#pragma mark - Lifecycle

/**
 *  initWithNibName
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self != nil) {
    // Ughh... I *hate* having to punch back through to the application delegate but I sort of painted myself
    // in too a bit of a corner here and I don't feel like making big architectural changes to allow for
    // the application delegate to pass the current librarian (or MOC) to the current action. Sorry.
    PECoachAppDelegate *appDelegate = (PECoachAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.librarian = appDelegate.librarian;
  }
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"newBackgroundImage.png"]];
  
  [super viewDidLoad];
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    //[Analytics logEvent:@"BASE VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [librarian_ release];
  
  [super dealloc];
}

@end
