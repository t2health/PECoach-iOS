//
//  CompareSituationsActionViewController.m
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
#import "CompareSituationsActionViewController.h"
#import "GraphSituationsActionViewController.h"
#import "PECoachConstants.h"
#import "Situation.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation CompareSituationsActionViewController

#pragma mark - Properties

@synthesize situations = situations_;

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
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = self.defaultSolidViewBackgroundColor;

  CGFloat labelWidth = self.formScrollView.frame.size.width - (kUITextFieldSUDSWidth * 2) - (kUIViewHorizontalMargin * 2) - (kUIViewHorizontalInset * 2);
  
  NSString *headingTitle = NSLocalizedString(@"HIERARCHY", nil);
  UILabel *headingLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, labelWidth, kUITextFieldDefaultHeight) text:headingTitle];    
  headingLabel.textColor = [UIColor grayColor];
  [self.formScrollView addSubview:headingLabel];
  
  NSString *startTitle = NSLocalizedString(@"START", nil);
  UILabel *startLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, kUITextFieldSUDSWidth, kUITextFieldDefaultHeight) text:startTitle];    
  startLabel.textAlignment = UITextAlignmentCenter;
  startLabel.textColor = [UIColor grayColor];
  [startLabel positionToTheRightOfView:headingLabel margin:kUIViewHorizontalMargin];
  [self.formScrollView addSubview:startLabel];
  
  NSString *endTitle = NSLocalizedString(@"FINAL", nil);
  UILabel *endLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, kUITextFieldSUDSWidth, kUITextFieldDefaultHeight) text:endTitle];    
  endLabel.textAlignment = UITextAlignmentCenter;
  endLabel.textColor = [UIColor grayColor];
  [endLabel positionToTheRightOfView:startLabel margin:kUIViewHorizontalMargin];
  [self.formScrollView addSubview:endLabel];

  __block UIView *lastView = headingLabel;
  
  [self.situations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    Situation *situation = (Situation *)obj;
    UILabel *label = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, labelWidth, kUITextFieldDefaultHeight) text:situation.title];  
    [label setTextColor:[UIColor whiteColor]];  
    [label positionBelowView:lastView margin:kUIViewVerticalMargin];
    
    UILabel *startLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, kUITextFieldSUDSWidth, kUITextFieldDefaultHeight) text:[situation.initialSUDSRating stringValue]];    
      startLabel.textAlignment = UITextAlignmentCenter;
      [startLabel setTextColor:[UIColor whiteColor]]; 
    [startLabel positionToTheRightOfView:label margin:kUIViewHorizontalMargin];
    [startLabel alignTopWithView:label];
    
    UILabel *endLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, kUITextFieldSUDSWidth, kUITextFieldDefaultHeight) text:[situation.finalSUDSRating stringValue]];    
      endLabel.textAlignment = UITextAlignmentCenter;
      [endLabel setTextColor:[UIColor whiteColor]]; 
    [endLabel positionToTheRightOfView:startLabel margin:kUIViewHorizontalMargin];
    [endLabel alignTopWithView:startLabel];

    [self.formScrollView addSubview:label];
    [self.formScrollView addSubview:startLabel];
    [self.formScrollView addSubview:endLabel];
    
    lastView = label;
  }];
  
  [self resizeContentViewToFitForScrollView:self.formScrollView];
  [self.saveButton setTitle:NSLocalizedString(@"Graph", nil) forState:UIControlStateNormal];
  self.saveButton.enabled = YES;
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"COMPARE SITUATIONS ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [situations_ release];
  
  [super dealloc];
}

#pragma mark - Instance Methods

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  GraphSituationsActionViewController *viewController = [[GraphSituationsActionViewController alloc] initWithSession:self.session action:self.action situationsArray:self.situations];
  viewController.showDoneButton = NO;
  viewController.showHomeButton = NO;
  
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

@end
