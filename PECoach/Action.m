//
//  Action.m
//  PECoach
//

#import "Action.h"
#import "Visit.h"

@implementation Action

#pragma mark - Attribute Properties

@dynamic completed;
@dynamic group;
@dynamic homeworkTitle;
@dynamic rank;
@dynamic title;
@dynamic type;

#pragma mark - Relationship Properties

@dynamic children;
@dynamic parent;
@dynamic session;
@dynamic visits;

#pragma mark - Accessors

- (void)addChildrenObject:(Action *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"children"] addObject:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeChildrenObject:(Action *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"children"] removeObject:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addChildren:(NSSet *)value {    
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"children"] unionSet:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeChildren:(NSSet *)value {
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"children"] minusSet:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)addVisitsObject:(Visit *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"visits" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"visits"] addObject:value];
    [self didChangeValueForKey:@"visits" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeVisitsObject:(Visit *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"visits" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"visits"] removeObject:value];
    [self didChangeValueForKey:@"visits" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addVisits:(NSSet *)value {    
    [self willChangeValueForKey:@"visits" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"visits"] unionSet:value];
    [self didChangeValueForKey:@"visits" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeVisits:(NSSet *)value {
    [self willChangeValueForKey:@"visits" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"visits"] minusSet:value];
    [self didChangeValueForKey:@"visits" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

@end
