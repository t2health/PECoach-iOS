//
//  FormActionViewController.m
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
#import "PECoachConstants.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation FormActionViewController

#pragma mark - Properties

@synthesize formScrollView = formScrollView_;
@synthesize saveButton = saveButton_;
@synthesize activeView = activeView_;

#pragma mark - Lifecycle

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  CGRect frame = self.view.frame;
  
  // Save Button (pinned to the bottom of the action view).
  UIButton *saveButton = [self buttonWithTitle:NSLocalizedString(@"Save", nil)];
  saveButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  saveButton.enabled = NO;
  
  [saveButton addTarget:self action:@selector(handleSaveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  
  // Horizontally center the save button and then position it at the bottom of the view.
  CGRect buttonFrame = saveButton.frame;
  CGFloat buttonXOrigin = (frame.size.width - buttonFrame.size.width) / 2;
  CGFloat buttonYOrigin = frame.size.height - buttonFrame.size.height - kUIViewVerticalInset;
  buttonFrame.origin = CGPointMake(buttonXOrigin, buttonYOrigin);
  saveButton.frame = buttonFrame;
  
  self.saveButton = saveButton;
  [self.view addSubview:self.saveButton];
  
  // UIScrollView that contains all the form fields.
  frame.size.height -= self.infoView.frame.size.height;
  frame.size.height -= (self.saveButton.frame.size.height + (kUIViewVerticalInset * 2));
  frame.origin.y = self.infoView.frame.size.height;
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
  scrollView.alwaysBounceVertical = YES;
  scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  [self.view addSubview:scrollView];
  self.formScrollView = scrollView;
  [scrollView release];
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.saveButton = nil;
  self.formScrollView = nil;
  self.activeView = nil;
  
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"FORM ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [saveButton_ release];
  [formScrollView_ release];
  [activeView_ release];
  
  [super dealloc];
}

#pragma mark - UIKeyboard Notification Methods

/**
 *  handleKeyboardDidShowNotification
 */
- (void)handleKeyboardDidShowNotification:(NSNotification*)notification {
  CGRect bounds = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  
  CGFloat keyboardOverlap = bounds.size.height;
  keyboardOverlap -= self.tabBarController.tabBar.frame.size.height;
  keyboardOverlap -= (self.view.frame.size.height - (self.formScrollView.frame.origin.y + self.formScrollView.frame.size.height));
  
  // Add the overlap amount to the bottom inset of the scroll view so that we can scroll the content up.
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardOverlap, 0.0);
  self.formScrollView.contentInset = contentInsets;
  self.formScrollView.scrollIndicatorInsets = contentInsets;
  
  // Tell the scroll view to scroll so that the active text field is visible.
  // Note that we slightly enlarge the frame so that there's a bit of vertical breathing
  // room between the top of the keyboard and the bottom of the active field.
  CGRect activeFrame = CGRectInset([self.formScrollView convertRect:self.activeView.frame fromView:self.activeView.superview], 0, -kUIViewVerticalInset) ;
  [self.formScrollView scrollRectToVisible:activeFrame animated:YES];
}

/**
 *  handleKeyboardWillHideNotification
 */
- (void)handleKeyboardWillHideNotification:(NSNotification*)aNotification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  [UIView animateWithDuration:0.3 animations:^(void) {
    self.formScrollView.contentInset = contentInsets;
    self.formScrollView.scrollIndicatorInsets = contentInsets;
  }];
}

#pragma mark - UITextFieldDelegate Methods

/**
 *  textFieldDidBeginEditing
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [super textFieldDidBeginEditing:textField];
  self.activeView = textField;
}

/**
 *  textFieldDidEndEditing
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
  self.activeView = nil;
  
  [super textFieldDidBeginEditing:textField];
}

#pragma mark - Instance Methods

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  // No-op.
}

@end
