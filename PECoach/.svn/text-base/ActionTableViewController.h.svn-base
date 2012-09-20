//
//  ActionTableViewController.h
//  PECoach
//

#import "ActionViewController.h"

@interface ActionTableViewController : ActionViewController<UITableViewDataSource, UITableViewDelegate> {
  UITableView *tableView_;
  UITableViewStyle tableViewStyle_;
}

// Properties
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, assign, readonly) UITableViewStyle tableViewStyle;

// Initializers
- (id)initWithSession:(Session *)session action:(Action *)action tableStyle:(UITableViewStyle)tableStyle;

// Instance Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView;

@end
