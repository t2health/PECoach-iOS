//
//  QuestionnaireAction.h
//  PECoach
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Action.h"

@interface QuestionnaireAction : Action {
}

// Attributes
@property (nonatomic, retain) NSDate *completionDate;

// Relationships
@property (nonatomic, retain) NSSet *questions;

// Transient Properties
@property(nonatomic, assign, readonly) NSUInteger score;

// Instance Methods
- (BOOL)isFinished;

@end
