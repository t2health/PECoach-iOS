//
//  HomeworkReviewViewController.m
//  PECoach
//

#import "HomeworkReviewViewController.h"
#import "Action.h"
#import "PECoachConstants.h"
#import "Recording.h"
#import "ScorecardsActionViewController.h"
#import "SituationsActionViewController.h"
#import "Session.h"
#import "UIView+Positionable.h"
#import "Visit.h"

@implementation HomeworkReviewViewController

#pragma mark - Properties

@synthesize previousActions = previousActions_;
@synthesize expandedIndexPaths = expandedIndexPaths_;
@synthesize dateFormatter = dateFormatter_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action
 */
- (id)initWithSession:(Session *)session action:(Action *)action {
  self = [super initWithSession:session action:action];
  if (self != nil) {
    previousActions_ = [[self.session.previousSession actionsForGroup:kActionGroupHomework] retain];
    expandedIndexPaths_ = [[NSMutableSet alloc] initWithCapacity:[previousActions_ count]];

    dateFormatter_ = [[NSDateFormatter alloc] init];
    [dateFormatter_ setDateStyle:NSDateFormatterShortStyle];
}
  
  return self;
}

/**
 *  dealloc
 */
- (void)dealloc {
  [previousActions_ release];
  [expandedIndexPaths_ release];
  [dateFormatter_ release];
  
  [super dealloc];
}

#pragma mark - UI Actions

/**
 *  handleToggleRowHeightButtonTapped
 */
- (void)handleToggleRowHeightButtonTapped:(id)sender event:(id)event {
  // Code taken from Apple's "Accessory" sample code example.
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
	if (indexPath != nil) {
    if ([self.expandedIndexPaths containsObject:indexPath] == YES) {
      [self.expandedIndexPaths removeObject:indexPath];
    } else {
      [self.expandedIndexPaths addObject:indexPath];
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
	}
}

#pragma mark - UITableViewDataSource Methods

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.previousActions count];
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Close your eyes kids, we're going to make a new UITableViewCell each time instead of dequeueing an existing one.
  // Since the potential number of rows in a table is very small and each row is potentially different, then there's
  // likely not as big a performance hit as one would expect. Besides, we're not scrolling a multi-thousand table here.
  UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  Action *action = [self.previousActions objectAtIndex:indexPath.row];
    
  // The magic number of 257 is (320 - (kUIViewHorizontalMargin * 3) - (width of button, 39))
  // It should really be computed dynamically.
  CGRect labelFrame = CGRectMake(kUIViewHorizontalMargin, 0.0, 257, kUITableCellDefaultHeight);
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
  titleLabel.font = self.defaultTableCellFont;
  titleLabel.text = action.homeworkTitle != nil ? action.homeworkTitle : action.title;
  titleLabel.textColor = self.defaultTextColor;

  NSArray *selectableRows = [NSArray arrayWithObjects:@"kAudioImaginalExposurePlaybackAction", @"kAppendSituationsAction", @"kEditSituationsAction", nil];
  if ([selectableRows containsObject:action.type] == YES) {
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    titleLabel.textColor = self.session.color;
    titleLabel.highlightedTextColor = [UIColor whiteColor];
  }
    
  // Accumulate the details for this item.  This is used for Accessibility (Voice Over)  
  NSMutableString *voDetails = [[NSMutableString alloc] initWithCapacity:50];
  [cell.contentView addSubview:titleLabel];
  
  BOOL isExpanded = [self.expandedIndexPaths containsObject:indexPath];
    
  if (isExpanded == YES) {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
    NSArray *sortedVisits = [action.visits sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    if ([sortedVisits count] > 0) {
      CGFloat yOffset = 0.0;
      for (Visit *visit in sortedVisits) {
        labelFrame = CGRectOffset(labelFrame, 0, labelFrame.size.height + yOffset);
        labelFrame.size.height = self.defaultTextFont.lineHeight;
          
        UILabel *visitLabel = [[UILabel alloc] initWithFrame:labelFrame];
        visitLabel.font = self.defaultTextFont;
        visitLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];

        NSMutableString *timestamp = [[NSMutableString alloc] initWithCapacity:32];
        [timestamp appendString:[self.dateFormatter stringFromDate:visit.startDate]];
        [voDetails appendString:[self.dateFormatter stringFromDate:visit.startDate]];
          
        NSTimeInterval interval = [visit.endDate timeIntervalSinceDate:visit.startDate];
        NSInteger minutes = floor(interval / 60);
        NSInteger seconds = round(interval - minutes * 60);
        
        NSString *minutesString = (minutes == 1 ? NSLocalizedString(@"minute", @"") : NSLocalizedString(@"minutes", @""));
        NSString *secondsString = (seconds == 1 ? NSLocalizedString(@"second", @"") : NSLocalizedString(@"seconds", @""));
        [timestamp appendString:[NSString stringWithFormat:@" - %i %@ %i %@", minutes, minutesString, seconds, secondsString]];
        [voDetails appendString:[NSString stringWithFormat:@" - %i %@ %i %@", minutes, minutesString, seconds, secondsString]];

        visitLabel.text = timestamp;
        [timestamp release];
        
        [cell.contentView addSubview:visitLabel];
        [visitLabel release];
        
        // The offset remains the same after the first label.
        yOffset = kUIViewVerticalMargin;
      }
    } else {
      labelFrame = CGRectOffset(labelFrame, 0, labelFrame.size.height);
      labelFrame.size.height = self.defaultTextFont.lineHeight;
      
      UILabel *visitLabel = [[UILabel alloc] initWithFrame:labelFrame];
      visitLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
      visitLabel.font = self.defaultTextFont;
      visitLabel.text = NSLocalizedString(@"Not completed.", @"");
      [voDetails appendString:visitLabel.text];  
      
      [cell.contentView addSubview:visitLabel];
      [visitLabel release];
    }
  }
  
  // Create a custom accessory button for toggling the height of the row. 
  UIImage *accessoryButtonImage = (!isExpanded ? [UIImage imageNamed:@"tableCellExpandedIcon.png"] : [UIImage imageNamed:@"tableCellCollapsedIcon.png"]);
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0.0, (tableView.rowHeight - accessoryButtonImage.size.height) / 2, accessoryButtonImage.size.width, accessoryButtonImage.size.height);
  [button setBackgroundImage:accessoryButtonImage forState:UIControlStateNormal];
  
  [button addTarget:self action:@selector(handleToggleRowHeightButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
  [button positionToTheRightOfView:titleLabel margin:kUIViewHorizontalMargin];
    
    // Accessibility (VoiceOver)
    [cell setIsAccessibilityElement:YES];
    [cell setAccessibilityTraits:UIAccessibilityTraitButton];
    
    // What we say depends on whether the cell is expanded (with detail) or collapsed (title only)
    [cell setAccessibilityLabel:[NSString stringWithFormat:@"%@ %@ %@",(isExpanded ? @"Collapse":@"Expand"), titleLabel.text,
                                                                                (isExpanded ? voDetails:@" ")]];
    
  [cell.contentView addSubview:button];

  [titleLabel release];
    [voDetails release];  
  
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:heightForRowAtIndexPath
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {  
  if ([self.expandedIndexPaths containsObject:indexPath] == YES) {
    Action *action = [self.previousActions objectAtIndex:indexPath.row];
    NSInteger actionCount = MAX(1, [action.visits count]);
    return (kUITableCellDefaultHeight + (self.defaultTextFont.lineHeight * actionCount) + (kUIViewVerticalMargin * actionCount));
  }
  
  return tableView.rowHeight;
}

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Action *action = [self.previousActions objectAtIndex:indexPath.row];
  ActionViewController *viewController = nil;
  
  if ([action.type isEqualToString:kActionTypeAudioImaginalExposurePlayback] == YES) {
    NSSet *scorecards = self.session.previousSession.recording.scorecards;
    viewController = [[ScorecardsActionViewController alloc] initWithSession:self.session 
                                                                      action:self.action scorecards:scorecards
                                                                 displayMode:kScorecardsActionViewDisplayModeGrid];
    viewController.infoTitle = NSLocalizedString(@"Review Imaginal Exposure Homework", @"");
  } else if ([action.type isEqualToString:kActionTypeAppendSituations] == YES) {
    viewController = [[SituationsActionViewController alloc] initWithSession:self.session 
                                                                      action:self.action 
                                                               situationMode:kSituationActionViewModeReviewSituations];
    viewController.infoTitle = NSLocalizedString(@"Review Added In Vivo Items", @"");
  } else if ([action.type isEqualToString:kActionTypeEditSituations] == YES) {
    // ** I think this should only be showing the scorecards from the previous session, but there's a note
    // ** in the spec for diagram 4.1.F that suggests otherwise. By showing all the situations from 
    // ** previous sessions, this screen is essentially a duplicate of diagram 4.2.D.
    NSSet *scorecards = [self.session allScorecardsIncludingPreviousSessions:YES];
    viewController = [[ScorecardsActionViewController alloc] initWithSession:self.session 
                                                                      action:self.action 
                                                                  scorecards:scorecards 
                                                                 displayMode:kScorecardsActionViewDisplayModeList];
    viewController.infoTitle = NSLocalizedString(@"Review In Vivo Exposure Assignment", @"");
  }
  
  if (viewController != nil) {
    viewController.showDoneButton = NO;
    viewController.showHomeButton = NO;
          
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
  }
    else
    {
        // Expand or Contract the row as needed
        if (indexPath != nil) {
            if ([self.expandedIndexPaths containsObject:indexPath] == YES) {
                [self.expandedIndexPaths removeObject:indexPath];
            } else {
                [self.expandedIndexPaths addObject:indexPath];
            }
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

@end