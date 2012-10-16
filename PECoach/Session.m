//
//  Session.m
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
#import <AVFoundation/AVFoundation.h>

#import "Session.h"
#import "Action.h"
#import "Librarian.h"
#import "Scorecard.h"
#import "Situation.h"

@implementation Session

#pragma mark - Attribute Properties

@dynamic color;
@dynamic icon;
@dynamic rank;
@dynamic subTitleColor;
@dynamic title;

#pragma mark - Relationship Properties

@dynamic actions;
@dynamic homeworkSituations;
@dynamic nativeSituations;
@dynamic nextSession;
@dynamic previousSession;
@dynamic recording;
@dynamic scorecards;

#pragma mark - Transient Properties

@synthesize audioRecorder = audioRecorder_;

#pragma mark - Lifecycle

/**
 *  dealloc
 */
- (void)dealloc {
  [audioRecorder_ stop];
  [audioRecorder_ release];
  
  [super dealloc];
}

#pragma mark - Accessors

- (void)addActionsObject:(Action *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"actions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"actions"] addObject:value];
    [self didChangeValueForKey:@"actions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeActionsObject:(Action *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"actions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"actions"] removeObject:value];
    [self didChangeValueForKey:@"actions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addActions:(NSSet *)value {    
    [self willChangeValueForKey:@"actions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"actions"] unionSet:value];
    [self didChangeValueForKey:@"actions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeActions:(NSSet *)value {
    [self willChangeValueForKey:@"actions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"actions"] minusSet:value];
    [self didChangeValueForKey:@"actions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)addHomeworkSituationsObject:(Situation *)value {    
  NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
  [self willChangeValueForKey:@"homeworkSituations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
  [[self primitiveValueForKey:@"homeworkSituations"] addObject:value];
  [self didChangeValueForKey:@"homeworkSituations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
  [changedObjects release];
}

- (void)removeHomeworkSituationsObject:(Situation *)value {
  NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
  [self willChangeValueForKey:@"homeworkSituations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
  [[self primitiveValueForKey:@"homeworkSituations"] removeObject:value];
  [self didChangeValueForKey:@"homeworkSituations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
  [changedObjects release];
}

- (void)addHomeworkSituations:(NSSet *)value {    
  [self willChangeValueForKey:@"homeworkSituations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
  [[self primitiveValueForKey:@"homeworkSituations"] unionSet:value];
  [self didChangeValueForKey:@"homeworkSituations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeHomeworkSituations:(NSSet *)value {
  [self willChangeValueForKey:@"homeworkSituations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
  [[self primitiveValueForKey:@"homeworkSituations"] minusSet:value];
  [self didChangeValueForKey:@"homeworkSituations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)addNativeSituationsObject:(Situation *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"nativeSituations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"nativeSituations"] addObject:value];
    [self didChangeValueForKey:@"nativeSituations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeNativeSituationsObject:(Situation *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"nativeSituations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"nativeSituations"] removeObject:value];
    [self didChangeValueForKey:@"nativeSituations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addNativeSituations:(NSSet *)value {    
    [self willChangeValueForKey:@"nativeSituations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"nativeSituations"] unionSet:value];
    [self didChangeValueForKey:@"nativeSituations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeNativeSituations:(NSSet *)value {
    [self willChangeValueForKey:@"nativeSituations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"nativeSituations"] minusSet:value];
    [self didChangeValueForKey:@"nativeSituations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

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
 *  actionsForGroup
 */
- (NSArray *)actionsForGroup:(NSString *)group {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == %@", group];
  NSSet *groupActions = [self.actions filteredSetUsingPredicate:predicate];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
  
  NSArray *sortedGroupActions = [groupActions sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  [sortDescriptor release];
  
  return sortedGroupActions;
}

/**
 *  scorecardForSituation
 */
- (Scorecard *)scorecardForSituation:(Situation *)situation {
  __block Scorecard *scorecard = nil;
  
  [self.scorecards enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    Scorecard *card = (Scorecard *)obj;
    if (card.situation == situation) {
      scorecard = card;
      *stop = YES;
    }
  }];
  
  return scorecard;
}

/**
 *  allScorecardsIncludingPreviousSessions
 */
- (NSSet *)allScorecardsIncludingPreviousSessions:(BOOL)includePreviousSessions {
  NSSet *cards = self.scorecards;
  
  if (includePreviousSessions == YES && self.previousSession != nil) {
    cards = [cards setByAddingObjectsFromSet:[self.previousSession allScorecardsIncludingPreviousSessions:YES]];
  }
  
  return cards;
}

/**
 *  isFinalSession
 */
- (BOOL)isFinalSession {
  return ([self.rank integerValue] == NSIntegerMax);
}

@end
