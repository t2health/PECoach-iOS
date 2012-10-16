//
//  Session.h
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
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Action;
@class AVAudioRecorder;
@class Recording;
@class Scorecard;
@class Situation;

@interface Session : NSManagedObject {
  AVAudioRecorder *audioRecorder_;
}

// Attributes
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSNumber *rank;
@property (nonatomic, retain) UIColor *subTitleColor;
@property (nonatomic, retain) NSString *title;

// Relationships
@property (nonatomic, retain) NSSet *actions;
@property (nonatomic, retain) NSSet *homeworkSituations;
@property (nonatomic, retain) NSSet *nativeSituations;
@property (nonatomic, retain) Session *nextSession;
@property (nonatomic, retain) Session *previousSession;
@property (nonatomic, retain) Recording *recording;
@property (nonatomic, retain) NSSet *scorecards;

// Transient Properties
@property(nonatomic, retain) AVAudioRecorder *audioRecorder;

- (void)addActionsObject:(Action *)value;
- (void)removeActionsObject:(Action *)value;
- (void)addActions:(NSSet *)value;
- (void)removeActions:(NSSet *)value;
- (void)addHomeworkSituationsObject:(Situation *)value;
- (void)removeHomeworkSituationsObject:(Situation *)value;
- (void)addHomeworkSituations:(NSSet *)value;
- (void)removeHomeworkSituations:(NSSet *)value;
- (void)addNativeSituationsObject:(Situation *)value;
- (void)removeNativeSituationsObject:(Situation *)value;
- (void)addNativeSituations:(NSSet *)value;
- (void)removeNativeSituations:(NSSet *)value;
- (void)addScorecardsObject:(Scorecard *)value;
- (void)removeScorecardsObject:(Scorecard *)value;
- (void)addScorecards:(NSSet *)value;
- (void)removeScorecards:(NSSet *)value;

// Instance Methods
- (NSArray *)actionsForGroup:(NSString *)group;
- (Scorecard *)scorecardForSituation:(Situation *)situation;
- (NSSet *)allScorecardsIncludingPreviousSessions:(BOOL)includePreviousSessions;
- (BOOL)isFinalSession;

@end
