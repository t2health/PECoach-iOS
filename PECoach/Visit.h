//
//  Visit.h
//  PECoach
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Action;

@interface Visit : NSManagedObject {
}

// Attributes
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;

// Relationships
@property (nonatomic, retain) Action * action;

@end
