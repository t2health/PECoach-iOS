//
//  ActionViewController.h
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

@class Action;
@class Session;

@interface ActionViewController : BaseViewController<UITextFieldDelegate> {
  // IBOutlets
  UIView *infoView_;
  UILabel *infoLabel_;

  Action *action_;
  Session *session_;
  UIFont *defaultTextFont_;
  UIFont *defaultTableCellFont_;
  UIColor *defaultTextColor_;
  UIColor *defaultSelectedTextColor_;
  UIColor *defaultSolidViewBackgroundColor_;
  UIColor *defaultBorderColor_;
  BOOL showHomeButton_;
  BOOL showDoneButton_;
  BOOL didWeShowBackgroundAlert; 
}

// Properties
@property(nonatomic, retain) IBOutlet UIView *infoView;
@property(nonatomic, retain) IBOutlet UILabel *infoLabel;

@property(nonatomic, retain) Action *action;
@property(nonatomic, retain) Session *session;

@property(nonatomic, copy) NSString *infoTitle;
@property(nonatomic, retain) UIFont *defaultTextFont;
@property(nonatomic, retain) UIFont *defaultTableCellFont;
@property(nonatomic, retain) UIColor *defaultSolidViewBackgroundColor;
@property(nonatomic, retain) UIColor *defaultTextColor;
@property(nonatomic, retain) UIColor *defaultSelectedTextColor;
@property(nonatomic, retain) UIColor *defaultBorderColor;
@property(nonatomic, assign) BOOL showHomeButton;
@property(nonatomic, assign) BOOL showDoneButton;
@property(nonatomic, assign) BOOL didWeShowBackgroundAlert;

// Initializers
- (id)initWithSession:(Session *)session action:(Action *)action;

// UI Actions
- (void)handleHomeButtonTapped:(id)sender;
- (void)handleDoneButtonTapped:(id)sender;
- (void)handleFakeBackButtonTapped:(id)sender;

// Keyboard Notification Methods
- (void)handleKeyboardDidShowNotification:(NSNotification*)notification;
- (void)handleKeyboardWillHideNotification:(NSNotification*)notification;

// Instance Methods
- (CGRect)contentFrame;
- (void)stopSessionRecording;
- (BOOL)isValidSUDSRating:(NSString *)rating;
- (BOOL)validateSUDSField:(UITextField *)field;
- (BOOL)validateSUDSFields:(NSArray *)fields;
- (UIAlertView *)alertViewForInvalidSUDSRating;
- (void)resizeContentViewToFitForScrollView:(UIScrollView *)scrollView;

- (UIButton *)buttonWithTitle:(NSString *)title;
- (UILabel *)formLabelWithFrame:(CGRect)frame text:(NSString *)text;
- (UITextField *)formTextFieldWithFrame:(CGRect)frame text:(NSString *)text;
- (UITextField *)SUDSTextFieldWithFrame:(CGRect)frame text:(NSString *)text;

@end
