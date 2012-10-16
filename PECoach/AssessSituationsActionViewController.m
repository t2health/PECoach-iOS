//
//  AssessSituationsActionViewController.m
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
#import "AssessSituationsActionViewController.h"
#import "PECoachConstants.h"
#import "Situation.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation AssessSituationsActionViewController

#pragma mark - Properties

@synthesize situations = situations_;
@synthesize SUDSTextFields = SUDSTextFields_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action:situations
 */
- (id)initWithSession:(Session *)session action:(Action *)action situations:(NSSet *)situations {
  self = [super initWithSession:session action:action];
  if (self != nil) {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    situations_ = [[situations sortedArrayUsingDescriptors:sortDescriptors] retain];
    SUDSTextFields_ = [[NSMutableArray alloc] initWithCapacity:[situations_ count]];
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = self.defaultSolidViewBackgroundColor;
  
  CGFloat textFieldWidth = kUITextFieldSUDSWidth;
  CGFloat labelWidth = self.formScrollView.frame.size.width - textFieldWidth - kUIViewHorizontalMargin - (kUIViewHorizontalInset * 2);
  
  NSString *headingTitle = NSLocalizedString(@"HIERARCHY", nil);
  UILabel *headingLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, labelWidth, kUITextFieldDefaultHeight) text:headingTitle];    
  headingLabel.textColor = [UIColor grayColor];
  [self.formScrollView addSubview:headingLabel];
  
  NSString *textFieldHeadingTitle = NSLocalizedString(@"SUDS", nil);
  UILabel *textFieldHeadingLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, textFieldWidth, kUITextFieldDefaultHeight) text:textFieldHeadingTitle];
  textFieldHeadingLabel.textColor = headingLabel.textColor;
  textFieldHeadingLabel.textAlignment = UITextAlignmentCenter;
  
  [textFieldHeadingLabel positionToTheRightOfView:headingLabel margin:kUIViewHorizontalMargin];
  [self.formScrollView addSubview:textFieldHeadingLabel];
  
  __block UIView *lastView = headingLabel;
  [self.SUDSTextFields removeAllObjects];
                                
  [self.situations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    Situation *situation = (Situation *)obj;
      UILabel *label = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, labelWidth, kUITextFieldDefaultHeight) text:situation.title];  
      [label setTextColor:[UIColor whiteColor]];   
    [label positionBelowView:lastView margin:kUIViewVerticalMargin];

    UITextField *textField = [self SUDSTextFieldWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, textFieldWidth, kUITextFieldDefaultHeight) text:[situation.finalSUDSRating stringValue]];
      [textField alignTopWithView:label];
      [textField setTextColor:[UIColor blackColor]]; 
    [textField positionToTheRightOfView:label margin:kUIViewHorizontalMargin];
    
    [self.formScrollView addSubview:label];
    [self.formScrollView addSubview:textField];

    [self.SUDSTextFields addObject:textField];
    lastView = label;
  }];
  
  [self resizeContentViewToFitForScrollView:self.formScrollView];
  self.saveButton.enabled = YES;
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [super viewDidUnload];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [situations_ release];
  [SUDSTextFields_ release];
  
  [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"ASSESS SITUATIONS ACTION VIEW"];
    [super viewDidAppear:animated];
}

#pragma mark - Instance Methods

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  if ([self validateSUDSFields:self.SUDSTextFields] == NO) {
    UIAlertView *alertView = [self alertViewForInvalidSUDSRating];
    [alertView show];
    return;
  }
  
  [self.SUDSTextFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    UITextField *textField = (UITextField *)obj;
    Situation *situation = [self.situations objectAtIndex:idx];
    situation.finalSUDSRating = [NSNumber numberWithInteger:[textField.text integerValue]];
  }];
  
  [self.navigationController popViewControllerAnimated:YES];
}

@end
