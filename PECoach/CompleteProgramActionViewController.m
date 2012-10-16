//
//  CompleteProgramActionViewController.m
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
#import "CompleteProgramActionViewController.h"
#import "Asset.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "UILabel+PELabel.h"
#import "Analytics.h"

@implementation CompleteProgramActionViewController

#pragma mark - Properties

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = self.defaultSolidViewBackgroundColor;
  
  Asset *asset = [self.librarian assetForKey:kAssetKeyProgramCompletionText];
  
  CGFloat width = self.formScrollView.frame.size.width - (kUIViewHorizontalInset * 2);
  UILabel *label = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, width, 0.0) text:asset.content];
  label.textColor = [UIColor whiteColor];
  label.font = self.defaultTextFont;
  
  [label resizeHeightAndWrapTextToFitWithinWidth:label.frame.size.width];
  [self.formScrollView addSubview:label];
  
  [self resizeContentViewToFitForScrollView:self.formScrollView];
  [self.saveButton setTitle:NSLocalizedString(@"Quit PE Coach", nil) forState:UIControlStateNormal];
  self.saveButton.enabled = NO;
  self.saveButton.hidden = YES;
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"COMPLETE PROGRAM ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [super dealloc];
}

#pragma mark - Instance Methods

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  // According to the spec, we're supposed to quit the app here, but according to Apple's documentation,
  // there is no officially supported way of doing that:
  // http://developer.apple.com/library/ios/#qa/qa1561/_index.html
}

@end
