//
//  CompletedQuestionnaireViewController.m
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
#include <QuartzCore/QuartzCore.h>
#import "CompletedQuestionnaireViewController.h"
#import "QuestionnairesReviewActionViewController.h"
#import "PECoachConstants.h"
#import "Question.h"
#import "QuestionnaireAction.h"
#import "Session.h"
#import "UILabel+PELabel.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation CompletedQuestionnaireViewController

#pragma mark - Properties

@synthesize questions = questions_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action
 */
- (id)initWithSession:(Session *)session action:(Action *)action {
  self = [super initWithSession:session action:action];
  if (self != nil) {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES];
    questions_ = [[((QuestionnaireAction *)self.action).questions sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]] retain];
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Header view for table. Frustratingly similar to the table view used in QuestionnaireViewController and
  // should therefore be created from a unified method in an ideal world.
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
  headerView.backgroundColor = [UIColor whiteColor];
  
  // Gray container view with border around it.
  UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalMargin, headerView.frame.size.width - kUIViewHorizontalMargin - kUIViewVerticalMargin, 0.0)];
  containerView.backgroundColor = self.defaultSolidViewBackgroundColor;
  containerView.layer.borderColor = self.defaultBorderColor.CGColor;
  containerView.layer.borderWidth = 1.0;
  
  // UILabel that shows "You have completed...."
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalMargin, 0.0, 0.0)];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.font = self.defaultTextFont;
  titleLabel.textAlignment = UITextAlignmentCenter;
  titleLabel.textColor = self.defaultTextColor;
  titleLabel.text = NSLocalizedString(@"You have completed your PCL Assessment", @"");
  
  [titleLabel resizeHeightAndWrapTextToFitWithinWidth:(containerView.frame.size.width - (kUIViewHorizontalMargin * 2))];
  [containerView addSubview:titleLabel];
  
  // UILabel that shows summary text.
  UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  textLabel.backgroundColor = [UIColor clearColor];
  textLabel.font = self.defaultTableCellFont;
  textLabel.textAlignment = UITextAlignmentCenter;
  textLabel.textColor = self.defaultTextColor;
  textLabel.text = [NSString stringWithFormat:@"%@ %u", NSLocalizedString(@"Your total score is", @""), ((QuestionnaireAction *)self.action).score];
  
  [textLabel resizeHeightAndWrapTextToFitWithinWidth:containerView.frame.size.width - (kUIViewHorizontalMargin * 2)];
  [textLabel alignLeftWithView:titleLabel];
  [textLabel positionBelowView:titleLabel margin:kUIViewVerticalMargin];
  [containerView addSubview:textLabel];
  
  [textLabel release];
  [titleLabel release];

  // Resize container view to fit both labels.
  [containerView resizeHeightToContainSubviewsWithMargin:kUIViewVerticalMargin];  
  [headerView addSubview:containerView];
  
  [containerView release];

  // Resize header view to fit container view.
  [headerView resizeHeightToContainSubviewsWithMargin:0.0];
  self.tableView.tableHeaderView = headerView;
  
  [headerView release];  
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
  [questions_ release];
  
  [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"COMPLETED QUESTIONNAIRE VIEW"];
    [super viewDidAppear:animated];
}

#pragma mark - UITableViewDataSource Methods

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.questions count];
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Shame on us... We're not re-using table cells because of the varying cell heights. Since the
  // potential number of rows in a table is so low, I doubt this will be much of a performance hit.
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  Question *question = [self.questions objectAtIndex:indexPath.row];
    
  CGFloat accessoryLabelWidth = 20.0;
  CGFloat bodyWidth = self.tableView.frame.size.width - (kUIViewHorizontalMargin * 4) - (accessoryLabelWidth * 2);
  
  // Index number
  UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalMargin, accessoryLabelWidth, self.defaultTextFont.lineHeight)];
  indexLabel.font = self.defaultTextFont;
  indexLabel.text = [NSString stringWithFormat:@"%@.", [[NSNumber numberWithUnsignedInteger:(indexPath.row + 1)] stringValue]];
  indexLabel.textColor = self.defaultTextColor;
    
  [cell.contentView addSubview:indexLabel];

  // Text of question.
  UILabel *bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, bodyWidth, 0.0)];
  bodyLabel.font = indexLabel.font;
  bodyLabel.text = question.text;
  bodyLabel.textColor = indexLabel.textColor;
  
  [bodyLabel resizeHeightAndWrapTextToFitWithinWidth:bodyWidth];
  [bodyLabel alignTopWithView:indexLabel];
  [bodyLabel positionToTheRightOfView:indexLabel margin:kUIViewHorizontalMargin];
    
    
    // Implement Accessibility
    [cell setIsAccessibilityElement:YES];
    [cell setAccessibilityTraits:UIAccessibilityTraitButton];
    
  [cell.contentView addSubview:bodyLabel];
  
  // Score
  UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, accessoryLabelWidth, self.defaultTextFont.lineHeight)];
  scoreLabel.font = [UIFont boldSystemFontOfSize:indexLabel.font.pointSize];
  scoreLabel.text = [question.answer stringValue];
  scoreLabel.textAlignment = UITextAlignmentCenter;
  scoreLabel.textColor = self.session.color;

  [scoreLabel alignTopWithView:bodyLabel];
  [scoreLabel positionToTheRightOfView:bodyLabel margin:kUIViewHorizontalMargin];
  
  [cell.contentView addSubview:scoreLabel];

  [indexLabel release];
  [bodyLabel release];
  [scoreLabel release];

  return [cell autorelease];
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:heightForRowAtIndexPath
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Yikes. Not the most elegant method. Should probably cache this or pre-compute it, or something...
  Question *question = [self.questions objectAtIndex:indexPath.row];
  UILabel *fakeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  fakeLabel.font = self.defaultTextFont;
  fakeLabel.text = question.text;
  
  CGFloat accessoryLabelWidth = 20.0;
  [fakeLabel resizeHeightAndWrapTextToFitWithinWidth:(self.tableView.frame.size.width - (kUIViewHorizontalMargin * 4) - (accessoryLabelWidth * 2))];
  CGFloat rowHeight = fakeLabel.frame.size.height;

  [fakeLabel release];

  return (rowHeight + (kUIViewVerticalMargin * 2));
}

@end
