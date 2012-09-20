//
//  QuestionnairesReviewActionViewController.m
//  PECoach
//

#include <QuartzCore/QuartzCore.h>
#import "QuestionnairesReviewActionViewController.h"
#import "CompletedQuestionnaireViewController.h"
#import "GraphPCLsActionViewController.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "QuestionnaireAction.h"
#import "Session.h"
#import "UILabel+PELabel.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation QuestionnairesReviewActionViewController

#pragma mark - Properties

@synthesize dateFormatter = dateFormatter_;
@synthesize questionnaireActions = questionnaireActions_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action
 */
- (id)initWithSession:(Session *)session action:(Action *)action {
  self = [super initWithSession:session action:action];
  if (self != nil) {
    questionnaireActions_ = [[self.librarian allCompletedQuestionnaireActions] retain];
    dateFormatter_ = [[NSDateFormatter alloc] init];
    [dateFormatter_ setDateStyle:NSDateFormatterShortStyle];
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Header view for table. 
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView setAutoresizingMask:UIViewAutoresizingNone];
  
  // Gray container view with border around it.
  UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalMargin, headerView.frame.size.width - kUIViewHorizontalMargin - kUIViewVerticalMargin, 0.0)];
  containerView.backgroundColor = self.defaultSolidViewBackgroundColor;
  containerView.layer.borderColor = self.defaultBorderColor.CGColor;
    containerView.layer.borderWidth = 1.0;
    
    // Place a Graph button in the header
    UIButton *graphButton = [self buttonWithTitle:NSLocalizedString(@"Graph", nil)];
    graphButton.enabled = YES;
    [graphButton addTarget:self action:@selector(handlegraphButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Figure out where to put this within the container view
     CGRect buttonFrame = graphButton.frame;
    buttonFrame.origin.x = containerView.frame.size.width - buttonFrame.size.width-5;  // Inside the right edge with a bit of a margin
    buttonFrame.origin.y = 10;              // Don't worry about centering this vertically...just move it down from the top a bit
     graphButton.frame = buttonFrame;
        
    [containerView addSubview:graphButton];
    
  // UILabel that shows "You have completed...."
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalMargin, 0.0, 0.0)];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.font = self.defaultTextFont;
  titleLabel.textAlignment = UITextAlignmentCenter;
  titleLabel.textColor = self.defaultTextColor;
  titleLabel.text = NSLocalizedString(@"You have completed your Final PCL Assessments. You can review all your PCL scores below.", nil);
  
    // Resize the label to allow room (plus margin) for the graph button we added above
    [titleLabel resizeHeightAndWrapTextToFitWithinWidth:(containerView.frame.size.width - (graphButton.frame.size.width+20))];
  [containerView addSubview:titleLabel];
  
  [titleLabel release];
        
  
  // Resize container view to fit both labels and the Graph Button
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

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"QUESTIONNAIRES REVIEW ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [dateFormatter_ release];
  [questionnaireActions_ release];
  
  [super dealloc];
}

#pragma mark - UITableViewDataSource Methods

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.questionnaireActions count];
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"UITableViewCellStyleDefault";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      cell.selectionStyle = UITableViewCellSelectionStyleBlue;
      
      // Implement Accessibility
      [cell setIsAccessibilityElement:YES];
      [cell setAccessibilityTraits:UIAccessibilityTraitButton];
    
    // Date label
    CGFloat dateLabelWidth = 100.0;
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, 0.0, dateLabelWidth, tableView.rowHeight)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = self.defaultTableCellFont;
    dateLabel.tag = 100;
    dateLabel.textColor = self.defaultTextColor;
    
    [cell.contentView addSubview:dateLabel];
    
    // Info label
    NSString *infoString = NSLocalizedString(@"PCL Score:", nil);
    CGSize infoLabelSize = [infoString sizeWithFont:self.defaultTextFont];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, infoLabelSize.width, tableView.rowHeight)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = self.defaultTextFont;
    infoLabel.text = infoString;
    infoLabel.textColor = self.defaultTextColor;
    
    [infoLabel positionToTheRightOfView:dateLabel margin:(kUIViewHorizontalMargin * 3)];
    [cell.contentView addSubview:infoLabel];
    
    // Score label
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kUITextFieldSUDSWidth, tableView.rowHeight)];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = [UIFont boldSystemFontOfSize:self.defaultTextFont.pointSize];
    scoreLabel.tag = 200;
    scoreLabel.textColor = self.session.color;
    
    [scoreLabel positionToTheRightOfView:infoLabel margin:kUIViewHorizontalMargin];
    [cell.contentView addSubview:scoreLabel];
    
    [scoreLabel release];
    [infoLabel release];
    [dateLabel release];
  }
  
  QuestionnaireAction *questionnaireAction = [self.questionnaireActions objectAtIndex:indexPath.row];
    
  UILabel *label = (UILabel *)[cell viewWithTag:100];
  label.text = [self.dateFormatter stringFromDate:questionnaireAction.completionDate];

  label = (UILabel *)[cell viewWithTag:200];
  label.text = [NSString stringWithFormat:@"%i", [questionnaireAction score]];
  
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  QuestionnaireAction *questionnaireAction = [self.questionnaireActions objectAtIndex:indexPath.row];
  CompletedQuestionnaireViewController *viewController = [[CompletedQuestionnaireViewController alloc] initWithSession:self.session action:questionnaireAction];
  viewController.showDoneButton = NO;
  viewController.showHomeButton = NO;
  
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

#pragma mark - UI Handlers
/**
 *  handlegraphButtonTapped
 */
- (void)handlegraphButtonTapped:(id)sender {
    GraphPCLsActionViewController *viewController = [[GraphPCLsActionViewController alloc] initWithSession:self.session action:self.action pclScoresArray:self.questionnaireActions];
    viewController.showDoneButton = NO;
    viewController.showHomeButton = NO;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
@end
