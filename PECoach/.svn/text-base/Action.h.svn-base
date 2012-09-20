//
//  Action.h
//  PECoach
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;
@class Visit;

@interface Action : NSManagedObject {
}

// Attributes
@property (nonatomic, assign) NSNumber *completed;
@property (nonatomic, retain) NSString *group;
@property (nonatomic, retain) NSString *homeworkTitle;
@property (nonatomic, retain) NSNumber *rank;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *type;

// Relationships
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) Action *parent;
@property (nonatomic, retain) Session *session;
@property (nonatomic, retain) NSSet *visits;

// Accessors
- (void)addChildrenObject:(Action *)value;
- (void)removeChildrenObject:(Action *)value;
- (void)addChildren:(NSSet *)value;
- (void)removeChildren:(NSSet *)value;
- (void)addVisitsObject:(Visit *)value;
- (void)removeVisitsObject:(Visit *)value;
- (void)addVisits:(NSSet *)value;
- (void)removeVisits:(NSSet *)value;

@end
