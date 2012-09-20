//
//  Situation.m
//  PECoach
//

#import "Situation.h"
#import "Session.h"
#import "Scorecard.h"

@implementation Situation

#pragma mark - Attribute Properties

@dynamic creationDate;
@dynamic finalSUDSRating;
@dynamic initialSUDSRating;
@dynamic title;

#pragma mark - Relationship Properties

@dynamic nativeSession;
@dynamic scorecards;
@dynamic sessions;

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


- (void)addSessionsObject:(Session *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"sessions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"sessions"] addObject:value];
    [self didChangeValueForKey:@"sessions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeSessionsObject:(Session *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"sessions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"sessions"] removeObject:value];
    [self didChangeValueForKey:@"sessions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addSessions:(NSSet *)value {    
    [self willChangeValueForKey:@"sessions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"sessions"] unionSet:value];
    [self didChangeValueForKey:@"sessions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeSessions:(NSSet *)value {
    [self willChangeValueForKey:@"sessions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"sessions"] minusSet:value];
    [self didChangeValueForKey:@"sessions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

@end
