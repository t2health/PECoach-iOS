//
//  QuestionnaireAction.m
//  PECoach
//
/*
 *
 * PECoach
 *
 * Copyright © 2009-2012 United States Government as represented by
 * the Chief Information Officer of the National Center for Telehealth
 * and Technology. All Rights Reserved.
 *
 * Copyright © 2009-2012 Contributors. All Rights Reserved.
 *
 * THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
 * REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
 * COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
 * AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
 * THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
 * INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
 * REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
 * DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
 * HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
 * RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.
 *
 * Government Agency: The National Center for Telehealth and Technology
 * Government Agency Original Software Designation: PECoach001
 * Government Agency Original Software Title: PECoach
 * User Registration Requested. Please send email
 * with your contact information to: robert.kayl2@us.army.mil
 * Government Agency Point of Contact for Original Software: robert.kayl2@us.army.mil
 *
 */
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