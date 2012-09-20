//
//  Recording.m
//  PECoach
//

#import "Recording.h"
#import "Scorecard.h"
#import "Session.h"

@implementation Recording

#pragma mark - Attribute Properties

@dynamic imaginalExposureEndsOffset;
@dynamic imaginalExposureStartsOffset;
@dynamic filePath;
@dynamic creationDate;

#pragma mark - Relationship Properties

@dynamic scorecards;
@dynamic session;

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

#pragma mark - Instance Methods

/**
 *  prepareForDeletion
 */
- (void)prepareForDeletion {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager removeItemAtPath:self.filePath error:nil];
}

@end
