//
//  QuestionnaireAction.m
//  PECoach
//

#import "QuestionnaireAction.h"
#import "Question.h"

@implementation QuestionnaireAction

#pragma mark - Attribute Properties

@dynamic completionDate;

#pragma mark - Relationship Properties

@dynamic questions;

#pragma mark - Transient Properties

@synthesize score;

#pragma mark - Accessors

- (void)addQuestionsObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"questions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"questions"] addObject:value];
    [self didChangeValueForKey:@"questions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeQuestionsObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"questions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"questions"] removeObject:value];
    [self didChangeValueForKey:@"questions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addQuestions:(NSSet *)value {    
    [self willChangeValueForKey:@"questions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"questions"] unionSet:value];
    [self didChangeValueForKey:@"questions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeQuestions:(NSSet *)value {
    [self willChangeValueForKey:@"questions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"questions"] minusSet:value];
    [self didChangeValueForKey:@"questions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

#pragma mark - Transient Accessors

/**
 *  score
 */
- (NSUInteger)score {
  __block NSUInteger tally = 0;
  
  [self.questions enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    Question *question = (Question *)obj;
    tally += [question.answer unsignedIntegerValue];
  }];
  
  return tally;
}

#pragma mark - Instance Methods

/**
 *  isFinished
 */
- (BOOL)isFinished {
  __block BOOL finished = YES;
  
  [self.questions enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    Question *question = (Question *)obj;
    finished = [question.answer integerValue] > 0;
    *stop = !finished;
  }];

  return finished;
}


@end