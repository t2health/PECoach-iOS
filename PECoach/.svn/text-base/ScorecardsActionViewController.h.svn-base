//
//  ScorecardsActionViewController.h
//  PECoach
//

#import "ActionTableViewController.h"

@class Scorecards;

typedef enum {
  kScorecardsActionViewDisplayModeGrid = 0,
  kScorecardsActionViewDisplayModeList,
} ScorecardsActionViewDisplayMode;

@interface ScorecardsActionViewController : ActionTableViewController {
  NSArray *scorecards_;
  NSDateFormatter *dateFormatter_;
  ScorecardsActionViewDisplayMode displayMode_;
}

// Properties
@property(nonatomic, retain) NSArray *scorecards;
@property(nonatomic, retain) NSDateFormatter *dateFormatter;
@property(nonatomic, assign) ScorecardsActionViewDisplayMode displayMode;

// Initializers
- (id)initWithSession:(Session *)session action:(Action *)action scorecards:(NSSet *)scorecards displayMode:(ScorecardsActionViewDisplayMode)displayMode;

// Instance Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForGridRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForListRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)configureGridCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView;
- (void)configureListCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView;

@end
