//
//  CreateSituationsActionViewController.h
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
#import "ActionTableViewController.h"

typedef enum {
  kSituationActionViewModeAppendSituations = 0,
  kSituationActionViewModeCreateSituations,
  kSituationActionViewModeEditSituations,
  kSituationActionViewModeListSituations,
  kSituationActionViewModeReviewSituations,
  kSituationActionViewModeSelectSituations,
} SituationActionViewMode;

@interface SituationsActionViewController : ActionTableViewController<UITextFieldDelegate> {
  UITextField *titleTextField_;
  UITextField *ratingTextField_;
  UIButton *saveButton_;
  
  SituationActionViewMode situationMode_;
  NSString *introLabelText_;
  BOOL showTableFooterView_;
  UITableViewCellSelectionStyle tableViewCellSelectionStyle_;
  NSArray *situations_;
}

// Properties
@property(nonatomic, retain) UITextField *titleTextField;
@property(nonatomic, retain) UITextField *ratingTextField;
@property(nonatomic, retain) UIButton *saveButton;

@property(nonatomic, assign) SituationActionViewMode situationMode;
@property(nonatomic, copy) NSString *introLabelText;
@property(nonatomic, assign, getter = shouldShowTableFooterView) BOOL showTableFooterView;
@property(nonatomic, assign) UITableViewCellSelectionStyle tableViewCellSelectionStyle;
@property(nonatomic, retain) NSArray *situations;

// Initializers
- (id)initWithSession:(Session *)session action:(Action *)action situationMode:(SituationActionViewMode)mode;

// UIActions
- (void)handleSaveButtonTapped:(id)sender;
- (void)handleInfoButtonTapped:(id)sender;

@end
