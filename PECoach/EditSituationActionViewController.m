//
//  EditSituationActionViewController.m
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
#import "EditSituationActionViewController.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "Scorecard.h"
#import "Session.h"
#import "Situation.h"
#import "UILabel+PELabel.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation EditSituationActionViewController

#pragma mark - Properties

@synthesize preSUDSTextField = preSUDSTextField_;
@synthesize postSUDSTextField = postSUDSTextField_;
@synthesize peakSUDSTextField = peakSUDSTextField_;

@synthesize scorecard = scorecard_;
@synthesize situation = situation_;

#pragma mark - Lifecycle

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.infoLabel.text = NSLocalizedString(@"Selected In Vivo Exposure Assignment", @"");
  self.view.backgroundColor = self.defaultSolidViewBackgroundColor;

  CGFloat labelWidth = [self contentFrame].size.width - (kUIViewHorizontalInset * 2);
  
  // Heading label
  UILabel *headingLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, labelWidth, self.defaultTableCellFont.lineHeight) text:NSLocalizedString(@"Situation", @"")];
    headingLabel.textColor = [UIColor whiteColor];  
  [self.formScrollView addSubview:headingLabel];
  
  // Title label
  UILabel *titleLabel = [self formLabelWithFrame:CGRectZero text:self.situation.title];
  titleLabel.font = self.defaultTextFont;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font =  [UIFont boldSystemFontOfSize:15.0];

  [titleLabel resizeHeightAndWrapTextToFitWithinWidth:labelWidth];
  [titleLabel alignLeftWithView:headingLabel];
  [titleLabel positionBelowView:headingLabel margin:kUIViewVerticalMargin];
  
  [self.formScrollView addSubview:titleLabel];
  
  // SUDS Fields
  __block UIView *lastView = titleLabel;
  NSArray *titles = [NSArray arrayWithObjects:NSLocalizedString(@"Pre - SUDS", @""),
                                              NSLocalizedString(@"Post - SUDS", @""), 
                                              NSLocalizedString(@"Peak - SUDS", @""), nil];
  
  [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
    CGFloat SUDSLabelWidth = 100.0;
    CGFloat textFieldWidth = 80.0;
    
    UILabel *label = [self formLabelWithFrame:CGRectMake(0.0, 0.0, SUDSLabelWidth, kUITextFieldDefaultHeight) text:obj];
    [label alignLeftWithView:lastView];
    [label positionBelowView:lastView margin:kUIViewVerticalMargin];
    label.textColor = [UIColor whiteColor];  
    [self.formScrollView addSubview:label];

    UITextField *textField = [self SUDSTextFieldWithFrame:CGRectMake(0.0, 0.0, textFieldWidth, kUITextFieldDefaultHeight) text:nil];
    
    [textField alignTopWithView:label];
    [textField positionToTheRightOfView:label margin:kUIViewHorizontalMargin];
      textField.textColor = [UIColor blackColor];  
    [self.formScrollView addSubview:textField];
    
    lastView = label;
    
    if (index == 0) {
      self.preSUDSTextField = textField;
    } else if (index == 1) {
      self.postSUDSTextField = textField;
    } else if (index == 2) {
      self.peakSUDSTextField = textField;
    }
  }];
  
  [self resizeContentViewToFitForScrollView:self.formScrollView];
  
  // If this Situation already has a scorecard for the current Session, then
  // fill in the text fields with the previous rating. 
  // 12/23/11 Don't do this...let them create a new (multiple) scorecard for each Session
    /*
  self.scorecard = [self.session scorecardForSituation:self.situation];
  if (self.scorecard != nil) {
    self.preSUDSTextField.text = [[self.scorecard preSUDSRating] stringValue];
    self.postSUDSTextField.text = [[self.scorecard postSUDSRating] stringValue];
    self.peakSUDSTextField.text = [[self.scorecard peakSUDSRating] stringValue];
  }
     */
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.preSUDSTextField = nil;
  self.postSUDSTextField = nil;
  self.peakSUDSTextField = nil;
  
  self.scorecard = nil;
  self.situation = nil;
  
  [super viewDidUnload];
}
- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"EDIT SITUATION ACTION VIEW"];
    [super viewDidAppear:animated];
}
/**
 *  dealloc
 */
- (void)dealloc {
  [preSUDSTextField_ release];
  [postSUDSTextField_ release];
  [peakSUDSTextField_ release];
  
  [scorecard_ release];
  [situation_ release];
  
  [super dealloc];
}

#pragma mark - UITextFieldDelegate Methods

/**
 *  textField:shouldChangeCharactersInRange
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  BOOL shouldChangeCharacters = [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
  if (shouldChangeCharacters == YES) {
    NSString *proposedString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    BOOL enableSaveButton = NO;
    
    // There's got to be a more elegant way to do this...
    if (textField == self.preSUDSTextField) {
      enableSaveButton = ([proposedString length] > 0 && 
                          [self.postSUDSTextField.text length] > 0 && 
                          [self.peakSUDSTextField.text length] > 0);
    } else if (textField == self.postSUDSTextField) {
      enableSaveButton = ([self.preSUDSTextField.text length] > 0 && 
                          [proposedString length] > 0 && 
                          [self.peakSUDSTextField.text length] > 0);
    } else if (textField == self.peakSUDSTextField) {
      enableSaveButton = ([self.preSUDSTextField.text length] > 0 && 
                          [self.postSUDSTextField.text length] > 0 && 
                          [proposedString length] > 0);
    }
    
    self.saveButton.enabled = enableSaveButton;
  }
  
  return shouldChangeCharacters;
}

#pragma mark - Instance Methods

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  NSArray *textFields = [NSArray arrayWithObjects:self.preSUDSTextField, self.postSUDSTextField, self.peakSUDSTextField, nil];
  if ([self validateSUDSFields:textFields] == NO) {
    [[self alertViewForInvalidSUDSRating] show];
    return;
  }

    // 12/23/11 Don't edit existing Scorecards...treat each entry as NEW
    /*
  if (self.scorecard != nil) {
    self.scorecard.preSUDSRating = [NSNumber numberWithInteger:[self.preSUDSTextField.text integerValue]];
    self.scorecard.postSUDSRating = [NSNumber numberWithInteger:[self.postSUDSTextField.text integerValue]];
    self.scorecard.peakSUDSRating = [NSNumber numberWithInteger:[self.peakSUDSTextField.text integerValue]];
  } else {
     */
    NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[self.preSUDSTextField.text integerValue]], @"preSUDSRating",
                            [NSNumber numberWithInteger:[self.postSUDSTextField.text integerValue]], @"postSUDSRating",
                            [NSNumber numberWithInteger:[self.peakSUDSTextField.text integerValue]], @"peakSUDSRating",
                            [NSDate date], @"creationDate", nil];
    
    Scorecard *newScorecard = [self.librarian insertNewScorecardWithValues:values];
    newScorecard.session = self.session;
    newScorecard.situation = self.situation;
  //}
  
  [self.navigationController popViewControllerAnimated:YES];
}

@end
