//
//  Librarian.h
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

@class Action;
@class Asset;
@class Question;
@class QuestionnaireAction;
@class Recording;
@class Scorecard;
@class Session;
@class Situation;
@class TextVideoAction;
@class Visit;

@interface Librarian : NSObject {
  NSString *applicationTitle_;
  
  NSURL *persistentStoreURL_;
  NSManagedObjectContext *managedObjectContext_;
  NSManagedObjectModel *managedObjectModel_;
  NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

// Properties
@property(nonatomic, copy) NSString *applicationTitle;
@property(nonatomic, retain) NSURL *persistentStoreURL;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Initializers
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

// Instance Methods
- (NSArray *)allSessions;
- (NSArray *)allSessionsIncludingFinalSession:(BOOL)includeFinalSession;
- (NSArray *)allSituations;
- (NSArray *)allCompletedQuestionnaireActions;
- (NSInteger)rankForNextSession;

- (Asset *)assetForKey:(NSString *)key;

- (Action *)insertNewActionWithValues:(NSDictionary *)values;
- (Asset *)insertNewAssetWithValues:(NSDictionary *)values;
- (Question *)insertNewQuestionWithValues:(NSDictionary *)values;
- (QuestionnaireAction *)insertNewQuestionnaireActionWithValues:(NSDictionary *)values;
- (Recording *)insertNewRecordingWithValues:(NSDictionary *)values;
- (Scorecard *)insertNewScorecardWithValues:(NSDictionary *)values;
- (Situation *)insertNewSituationWithValues:(NSDictionary *)values;
- (TextVideoAction *)insertNewTextVideoActionWithValues:(NSDictionary *)values;
- (Session *)insertNewSessionWithValues:(NSDictionary *)values;
- (Session *)insertNewSessionWithSession:(Session *)session;
- (Visit *)insertNewVisitWithValues:(NSDictionary *)values;
- (NSManagedObject *)insertNewObjectForEntityForName:(NSString *)entityName withValues:(NSDictionary *)valuesDictionary;
- (void)deleteObject:(NSManagedObject *)object;
- (void)save;

- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)fetchLimit;

@end
