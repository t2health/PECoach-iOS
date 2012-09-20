//
//  Scorecard.m
//  PECoach
//

#import "Scorecard.h"
#import "Situation.h"

@implementation Scorecard

#pragma mark - Attribute Properties

@dynamic creationDate;
@dynamic peakSUDSRating;
@dynamic postSUDSRating;
@dynamic preSUDSRating;

#pragma mark - Relationship Properties

@dynamic recording;
@dynamic session;
@dynamic situation;

#pragma mark - Accessors

- (void)addScorecardsObject:(Scorecard *)value {    
  NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
  [self willChangeValueForKey:@"scorecards" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
  [[self primitiveValueForKey:@"scorecards"] addObject:value];
  [self didChangeValueForKey:@"scorecards" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
  [changedObjects release];
}

- (void)removeScorecardsObject:(Scorecard *)value {
  NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
  [self willChangeValueForKey:@"scorecards" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
  [[self primitiveValueForKey:@"scorecards"] removeObject:value];
  [self didChangeValueForKey:@"scorecards" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
  [changedObjects release];
}

- (void)addScorecards:(NSSet *)value {    
  [self willChangeValueForKey:@"scorecards" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
  [[self primitiveValueForKey:@"scorecards"] unionSet:value];
  [self didChangeValueForKey:@"scorecards" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeScorecards:(NSSet *)value {
  [self willChangeValueForKey:@"scorecards" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
  [[self primitiveValueForKey:@"scorecards"] minusSet:value];
  [self didChangeValueForKey:@"scorecards" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

@end
