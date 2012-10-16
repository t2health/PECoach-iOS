//
//  LostPINViewController.h
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

@class StartupManager;

@interface LostPINViewController : BaseViewController<UIAlertViewDelegate, UITextFieldDelegate> {
  UILabel *primaryLabel_;
  UITextField *primaryTextField_;
  UILabel *secondaryLabel_;
  UITextField *secondaryTextField_;
  StartupManager *startupManager_;
}

// Properties
@property(nonatomic, retain) IBOutlet UILabel *primaryLabel;
@property(nonatomic, retain) IBOutlet UITextField *primaryTextField;
@property(nonatomic, retain) IBOutlet UILabel *secondaryLabel;
@property(nonatomic, retain) IBOutlet UITextField *secondaryTextField;
@property(nonatomic, retain) StartupManager *startupManager;

// Initializers
- (id)initWithStartupManager:(StartupManager *)manager;

// IBActions
- (IBAction)handleCancelButtonTapped:(id)sender;
- (IBAction)handleSubmitButtonTapped:(id)sender;

// Instance Methods
- (void)showPINViewController;

@end
