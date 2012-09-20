//
//  SessionsMenuViewController.h
//  PECoach
//

#import <UIKit/UIKit.h>
#import "SessionsMenuDelegate.h"

@class Librarian;
@class Action;
@class Visit;

@interface SessionsMenuViewController : UITableViewController <UIAlertViewDelegate> {
  Librarian *librarian_;
  id<SessionsMenuDelegate> delegate_;
}

// Properties
@property(nonatomic, retain) Librarian *librarian;
@property(nonatomic, assign) id<SessionsMenuDelegate> delegate;

// Initializers
- (id)initWithLibrarian:(Librarian *)librarian;

// UI Actions
- (void)handleAddButtonTapped:(id)sender;

@end
