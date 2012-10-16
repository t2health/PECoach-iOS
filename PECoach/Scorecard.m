//
//  Scorecard.m
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
