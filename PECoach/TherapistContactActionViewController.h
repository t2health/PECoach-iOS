//
//  TherapistContactActionViewController.h
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
#import "FormActionViewController.h"

@interface TherapistContactActionViewController : FormActionViewController {
  UILabel *nameLabel_;
  UILabel *phoneLabel_;
  UILabel *cellLabel_;
  UILabel *emailLabel_;
  
  UITextField *nameTextField_;
  UITextField *phoneTextField_;
  UITextField *cellTextField_;
  UITextField *emailTextField_;
  
  UIButton *editButton_;
}

// Properties
@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) UILabel *phoneLabel;
@property(nonatomic, retain) UILabel *cellLabel;
@property(nonatomic, retain) UILabel *emailLabel;

@property(nonatomic, retain) UITextField *nameTextField;
@property(nonatomic, retain) UITextField *phoneTextField;
@property(nonatomic, retain) UITextField *cellTextField;
@property(nonatomic, retain) UITextField *emailTextField;

@property(nonatomic, retain) UIButton *editButton;

// UI Actions
- (void)handleSaveButtonTapped:(id)sender;
- (void)handleEditButtonTapped:(id)sender;
- (void)handleAddToContactsButtonTapped:(id)sender;
- (void)handleEmailTappedGesture:(UIGestureRecognizer *)gestureRecognizer;
- (void)handlePhoneNumberTappedGesture:(UIGestureRecognizer *)gestureRecognizer;

// Instance Methods
- (void)loadContactInfo;
 
@end
