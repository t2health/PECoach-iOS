//
//  ActionGroupViewController.h
//  PECoach
//

#import <EventKitUI/EventKitUI.h>
#import "ActionTableViewController.h"

@class Action;
@class Session;

@interface ActionGroupViewController : ActionTableViewController<EKEventEditViewDelegate> {
  NSString *actionGroup_;
  NSArray *actionSet_;
  BOOL showingChildrenActions_;
}

// Properties
@property(nonatomic, copy) NSString *actionGroup;
@property(nonatomic, retain, readonly) NSArray *actionSet;
@property(nonatomic, assign) BOOL showingChildrenActions;

// Initializers
- (id)initWithSession:(Session *)session actionGroup:(NSString *)group;
- (id)initWithSession:(Session *)session action:(Action *)action;

// Instance Methods
- (void)handleActionSelected:(Action *)action;

@end
