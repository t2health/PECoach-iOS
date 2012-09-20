//
//  ScorecardsActionViewController.m
//  PECoach
//

#import "ScorecardsActionViewController.h"
#import "Action.h"
#import "PECoachConstants.h"
#import "Recording.h"
#import "Scorecard.h"
#import "Session.h"
#import "Situation.h"
#import "UILabel+PELabel.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

#define kSmallLabelWidth 32.0
#define kLargeLabelWidth 68.0

@implementation ScorecardsActionViewController

#pragma mark - Properties

@synthesize scorecards = scorecards_;
@synthesize dateFormatter = dateFormatter_;
@synthesize displayMode = displayMode_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action:scorecards:displayMode
 */
- (id)initWithSession:(Session *)session action:(Action *)action scorecards:(NSSet *)scorecards displayMode:(ScorecardsActionViewDisplayMode)displayMode {
  self = [super initWithSession:session action:action];
  if (self != nil) {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    scorecards_ = [[scorecards sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]] retain];
    displayMode_ = displayMode;
    dateFormatter_ = [[NSDateFormatter alloc] init];
    [dateFormatter_ setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter_ setTimeStyle:NSDateFormatterShortStyle];
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  // There's only a header view in grid mode.
  if (self.displayMode == kScorecardsActionViewDisplayModeGrid) {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0.0)];
    
    __block CGFloat xOrigin = kUIViewHorizontalMargin;
    CGFloat labelHeight = self.defaultTableCellFont.lineHeight;
    NSArray *labelTitles = [NSArray arrayWithObjects:NSLocalizedString(@"#", @""), 
                            NSLocalizedString(@"DATE", @""),
                            NSLocalizedString(@"TIME", @""), 
                            NSLocalizedString(@"SUDS", @""), nil];
    
    NSArray *labelSubTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Pre", @""),
                               NSLocalizedString(@"Post", @""),
                               NSLocalizedString(@"Peak", @""), nil];
    
    [labelTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      CGFloat labelWidth = (idx == 0 ? kSmallLabelWidth : kLargeLabelWidth);
      if (idx == 3) {
        labelWidth = (kSmallLabelWidth * 3) + (kUIViewHorizontalMargin * 2);
      }
      
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, kUIViewVerticalMargin, labelWidth, labelHeight)];
      label.backgroundColor = [UIColor clearColor];
      label.font = self.defaultTableCellFont;
      label.text = obj;
      label.textAlignment = UITextAlignmentCenter;
      label.textColor = self.session.color;
      
      [headerView addSubview:label];
      [label release];
      
      if (idx == 3) {
        [labelSubTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          CGFloat xOffset = kSmallLabelWidth + (kLargeLabelWidth * 2) + (kUIViewHorizontalMargin * 4);
          UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + (idx * (kSmallLabelWidth + kUIViewHorizontalMargin)), labelHeight + (kUIViewVerticalMargin * 2), kSmallLabelWidth, self.defaultTextFont.lineHeight)];
          subLabel.backgroundColor = [UIColor clearColor];
          subLabel.font = self.defaultTextFont;
          subLabel.text = obj;
          subLabel.textAlignment = UITextAlignmentCenter;
          subLabel.textColor = self.session.color;
          
          [headerView addSubview:subLabel];
          [subLabel release];
        }];
      }
      xOrigin += labelWidth + kUIViewHorizontalMargin;
    }];
    
    
    [headerView resizeHeightToContainSubviewsWithMargin:0.0];
    self.tableView.tableHeaderView = headerView;
    [headerView release];
  }
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"SCORECARDS ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [scorecards_ release];
  [dateFormatter_ release];
  
  [super dealloc];
}

#pragma mark - UITableViewDataSource Methods

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.scorecards count];
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  
  if (self.displayMode == kScorecardsActionViewDisplayModeGrid) {
    cell = [self tableView:tableView cellForGridRowAtIndexPath:indexPath];
    [self configureGridCell:cell atIndexPath:indexPath withTableView:tableView];
  } else {
    cell = [self tableView:tableView cellForListRowAtIndexPath:indexPath];
    [self configureListCell:cell atIndexPath:indexPath withTableView:tableView];
  }
    
    // Implement Accessibility
    [cell setIsAccessibilityElement:YES];
    [cell setAccessibilityTraits:UIAccessibilityTraitButton];
    
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:heightForRowAtIndexPath
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.displayMode == kScorecardsActionViewDisplayModeGrid) {
    return tableView.rowHeight;
  }
  
  CGFloat listRowHeight = (kUIViewVerticalMargin * 2) + (kUIViewVerticalInset * 2);
  listRowHeight += self.defaultTableCellFont.lineHeight * 2;
  listRowHeight += self.defaultTextFont.lineHeight * 3;
  
  Scorecard *scorecard = [self.scorecards objectAtIndex:indexPath.row];
  Situation *situation = scorecard.situation;
  CGSize constraintSize = CGSizeMake(tableView.frame.size.width - (kUIViewHorizontalInset * 2), CGFLOAT_MAX);
  CGSize optimalSize = [situation.title sizeWithFont:self.defaultTextFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap]; 
  
  listRowHeight += optimalSize.height;
  
  return listRowHeight;
}


#pragma mark - Instance Methods

/**
 *  tableView:cellForGridRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForGridRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *sGridCellIdentifier = @"GridCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sGridCellIdentifier];

  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sGridCellIdentifier] autorelease];
    
    CGFloat labelHeight = tableView.rowHeight;
    CGFloat smallLabelWidth = kSmallLabelWidth;
    CGFloat largeLabelWidth = kLargeLabelWidth; 
    
    for (NSInteger i = 0; i < 6; i++) {
      BOOL isTimestamp = (i == 1 || i == 2);
      CGFloat width = (isTimestamp ? largeLabelWidth : smallLabelWidth);
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, 0.0, width, labelHeight)];
      label.backgroundColor = [UIColor clearColor];
      label.font = self.defaultTextFont;
      label.tag = (i + 100);
      label.textAlignment = UITextAlignmentCenter;
      label.textColor = self.defaultTextColor;
      
      UIView *lastLabel = [cell.contentView viewWithTag:((i - 1) + 100)];
      if (lastLabel != nil) {
        [label positionToTheRightOfView:lastLabel margin:kUIViewHorizontalMargin];
      }
      
      [cell.contentView addSubview:label];
      [label release];
    }
  }
  
  return cell;
}

/**
 *  tableView:cellForListRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForListRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *sListCellIdentifier = @"ListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sListCellIdentifier];
  
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sListCellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat labelWidth = tableView.frame.size.width - (kUIViewHorizontalMargin * 2);
      
    NSArray *SUDSLabelNames = [NSArray arrayWithObjects:NSLocalizedString(@"Pre SUDS", @""),
                                                        NSLocalizedString(@"Post SUDS", @""),
                                                        NSLocalizedString(@"Peak SUDS", @""), nil];
    
    for (NSInteger i = 0; i < 6; i++) {
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, labelWidth, self.defaultTableCellFont.lineHeight)];
      label.backgroundColor = [UIColor clearColor];
      label.font = (i == 0 || i == 2) ? self.defaultTableCellFont : self.defaultTextFont;
      label.tag = 200 + i;
      label.textColor = self.defaultTextColor;
      
      [cell.contentView addSubview:label];

      // SUDS prefix label
      if (i > 2) {
        CGRect labelFrame = label.frame;
        labelFrame.size.width = 100.0;
        label.frame = labelFrame;
        label.text = [SUDSLabelNames objectAtIndex:i - 3];
        
        UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, self.defaultTextFont.lineHeight)];
        ratingLabel.backgroundColor = [UIColor clearColor];
        ratingLabel.font = self.defaultTextFont;
        ratingLabel.tag = 300 + i;
        ratingLabel.textColor = self.defaultTextColor;
        
        [ratingLabel alignTopWithView:label];
        [ratingLabel positionToTheRightOfView:label margin:kUIViewHorizontalMargin];
        
        [cell.contentView addSubview:ratingLabel];
        [ratingLabel release];
      }
      
      [label release];
    }
  }
  
  return cell;
}

/**
 *  configureGridCell:atIndexPath:withTableView
 */
- (void)configureGridCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
  Scorecard *scorecard = (Scorecard *)[self.scorecards objectAtIndex:indexPath.row];
  
  // Scorecard number.
  UILabel *label = (UILabel *)[cell viewWithTag:100];
  label.text = [NSString stringWithFormat:@"%i.", indexPath.row + 1];
  
  // Date
  label = (UILabel *)[cell viewWithTag:101];
  [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
  [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  label.text = [self.dateFormatter stringFromDate:scorecard.creationDate];
  
  // Time
  label = (UILabel *)[cell viewWithTag:102];
  [self.dateFormatter setDateStyle:NSDateFormatterNoStyle];
  [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  label.text = [self.dateFormatter stringFromDate:scorecard.creationDate];
  
  // Pre SUDS Rating
  label = (UILabel *)[cell viewWithTag:103];
  label.text = [scorecard.preSUDSRating stringValue];
  
  // Post SUDS Rating
  label = (UILabel *)[cell viewWithTag:104];
  label.text = [scorecard.postSUDSRating stringValue];
  
  // Peak SUDS Rating
  label = (UILabel *)[cell viewWithTag:105];
  label.text = [scorecard.peakSUDSRating stringValue];
}

/**
 *  configureListCell:atIndexPath:withTableView
 */
- (void)configureListCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
  Scorecard *scorecard = (Scorecard *)[self.scorecards objectAtIndex:indexPath.row];
  Situation *situation = scorecard.situation;

  // Heading
  UILabel *headingLabel = (UILabel *)[cell viewWithTag:200];
    // 05/30/2012 Remove # from label
    //headingLabel.text = [NSString stringWithFormat:@"%@ %i:", NSLocalizedString(@"Situation", @""), indexPath.row + 1];
    headingLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"Situation", @"")];
  
  // Title
  UILabel *titleLabel = (UILabel *)[cell viewWithTag:201];
  titleLabel.text = situation.title;
  
  [titleLabel resizeHeightAndWrapTextToFitWithinWidth:titleLabel.frame.size.width];
  [titleLabel positionBelowView:headingLabel margin:0];
  
  // Timestamp
  UILabel *timestampLabel = (UILabel *)[cell viewWithTag:202];
  [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
  [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  timestampLabel.text = [self.dateFormatter stringFromDate:scorecard.creationDate];
  
  [timestampLabel positionBelowView:titleLabel margin:kUIViewVerticalMargin];
  
  // Pre SUDS
  UILabel *preSUDSLabel = (UILabel *)[cell viewWithTag:203];
  [preSUDSLabel positionBelowView:timestampLabel margin:kUIViewVerticalMargin];

  preSUDSLabel = (UILabel *)[cell viewWithTag:303];
  preSUDSLabel.text = [scorecard.preSUDSRating stringValue];
  [preSUDSLabel positionBelowView:timestampLabel margin:kUIViewVerticalMargin];

  // Post SUDS
  UILabel *postSUDSLabel = (UILabel *)[cell viewWithTag:204];
  [postSUDSLabel positionBelowView:preSUDSLabel margin:0];

  postSUDSLabel = (UILabel *)[cell viewWithTag:304];
  postSUDSLabel.text = [scorecard.postSUDSRating stringValue];
  [postSUDSLabel positionBelowView:preSUDSLabel margin:0];

  // Peak SUDS
  UILabel *peakSUDSLabel = (UILabel *)[cell viewWithTag:205];
  [peakSUDSLabel positionBelowView:postSUDSLabel margin:0];
  
  peakSUDSLabel = (UILabel *)[cell viewWithTag:305];
  peakSUDSLabel.text = [scorecard.peakSUDSRating stringValue];
  
  [peakSUDSLabel positionBelowView:postSUDSLabel margin:0];
}

@end
