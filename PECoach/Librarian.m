//
//  Librarian.m
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
#import "Librarian.h"
#import "Action.h"
#import "PECoachConstants.h"
#import "Asset.h"
#import "Question.h"
#import "QuestionnaireAction.h"
#import "Recording.h"
#import "Scorecard.h"
#import "Session.h"
#import "Situation.h"

@implementation Librarian

#pragma mark - Properties

@synthesize applicationTitle = applicationTitle_;
@synthesize persistentStoreURL = persistentStoreURL_;
@synthesize managedObjectModel = managedObjectModel_;
@synthesize managedObjectContext = managedObjectContext_;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator_;

#pragma mark - Lifecycle

/**
 *  init
 */
- (id)init {
  self = [super init];
  if (self != nil) {
    // No-op for now.
  }
  
  return self;
}

/**
 *  initWithManagedObjectContext
 */
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
  self = [self init];
  if (self != nil) {
    managedObjectContext_ = [context retain];
    persistentStoreCoordinator_ = [[context persistentStoreCoordinator] retain];
    managedObjectModel_ = [[persistentStoreCoordinator_ managedObjectModel] retain];
  }
  return self;
}

/**
 *  dealloc
 */
- (void)dealloc {
  [persistentStoreURL_ release];
  [managedObjectModel_ release];
  [managedObjectContext_ release];
  [persistentStoreCoordinator_ release];
  
  [super dealloc];
}

#pragma mark - Property Accessors

/**
 *  applicationTitle
 */
- (NSString *)applicationTitle {
  if (applicationTitle_ == nil) {
    Asset *asset = [self assetForKey:kAssetKeyApplicationTitle];
    applicationTitle_ = [asset.content copy];
  }
  
  return applicationTitle_;
}

/**
 *  persistentStoreURL
 */
- (NSURL *)persistentStoreURL {
  if (persistentStoreURL_ == nil) {
    NSString *applicationDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    persistentStoreURL_ = [[NSURL alloc] initFileURLWithPath:[applicationDirectoryPath stringByAppendingPathComponent:@"PECoach.sqlite"]];
  }
  
  return persistentStoreURL_;
}

/**
 *  managedObjectContext
 */
- (NSManagedObjectContext *)managedObjectContext {
  if (managedObjectContext_ == nil) {
    managedObjectContext_ = [[NSManagedObjectContext alloc] init];
    [managedObjectContext_ setUndoManager:nil];
    [managedObjectContext_ setPersistentStoreCoordinator:self.persistentStoreCoordinator];
  }
  
  return managedObjectContext_;
}

/**
 *  managedObjectModel
 */
- (NSManagedObjectModel *)managedObjectModel {
  if (managedObjectModel_ == nil) {
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"PECoach" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  }
  
  return managedObjectModel_;
}

/**
 *  persistentStoreCoordinator
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (persistentStoreCoordinator_ == nil) {  
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.persistentStoreURL options:nil error:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }    
  }
  
  return persistentStoreCoordinator_;
}

#pragma mark - Instance Methods

/**
 *  save
 */
- (void)save {
  NSError *error = nil;
  if ([self.managedObjectContext hasChanges]) {
    [self.managedObjectContext save:&error];
  }
}

/**
 *  allSessions
 */
- (NSArray *)allSessions {
  return [self allSessionsIncludingFinalSession:YES];
}

/**
 *  allSessionsIncludingFinalSession
 */
- (NSArray *)allSessionsIncludingFinalSession:(BOOL)includeFinalSession {
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
  NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  NSPredicate *predicate = nil;
  
  if (includeFinalSession == NO) {
    predicate = [NSPredicate predicateWithFormat:@"%K < %@", @"rank", [NSNumber numberWithInteger:NSIntegerMax]];
  }

   // NSLog(@"include Final Session: %@",includeFinalSession?@"YES":@"NO");
    
    // 06/05/12 Ok...this will give us all of the sessions...but basically in chronological order of their creation
    // But these items are in an order linked-list and that is the way we want to pass them back.
  NSArray *sessions = [self fetchManagedObjectsWithEntityName:@"Session" predicate:predicate sortDescriptors:descriptors fetchLimit:0];
    
    /*
    if (sessions)
        NSLog(@"session cnt: %d",[sessions count]);
    
    // Let's look at the array of sessions
    NSEnumerator *e = [sessions objectEnumerator];
    id object;
    int cnt=0;
    while (object = [e nextObject]) {
        Session *mySession = (Session *)object;
        NSLog(@"Librarian (ARRAY order) cnt: %d  title:%@",cnt++,mySession.title);
    }
    */
    
    NSMutableArray *orderedSessions = NULL;
    
    if (sessions) {         // Make sure we got something
        
        if ([sessions count]) {   // ...at least 1 something
            // Now process them via the linked list
            orderedSessions = [NSMutableArray arrayWithCapacity:[sessions count]];
            [orderedSessions addObject:[sessions objectAtIndex:0]];                     // First element is always first!
            Session *currentSession = [sessions objectAtIndex:0];
            
            int nCnt = 1;
            while (currentSession.nextSession != nil && nCnt++ < [sessions count]) {
                // Find what is next...
                currentSession = currentSession.nextSession;
                
                // But only add it if it was in the original array
                // (If we asked to exclude the Final Session, it will not be in the array...
                // ....but we might still find it through the linked list...
                // .......we don't want it if it wasn't here to begin with!)
                BOOL bAdd = FALSE;
                for (int i=0; i<[sessions count];i++) {
                    if (currentSession == [sessions objectAtIndex:i]) {
                        bAdd = TRUE;
                        break;
                    }
                }
                
                if (bAdd)
                    [orderedSessions addObject:currentSession];
            }
        }
      
    }
    
    /*
    // Let's look at the array of sessions
    NSEnumerator *ee = [orderedSessions objectEnumerator];
    id objectee;
    int cntee=0;
    while (objectee = [ee nextObject]) {
        Session *mySession = (Session *)objectee;
        NSLog(@"Librarian (LINK order) cnt: %d  title:%@",cntee++,mySession.title);
    }
    
    NSLog(@"include Final Session: %@",includeFinalSession?@"YES":@"NO");
    */
    
  [descriptors release];
  [sortDescriptor release];
  
  //return sessions;
    return orderedSessions;
}

/**
 *  allSituations
 */
- (NSArray *)allSituations {
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
  NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  
  NSArray *situations = [self fetchManagedObjectsWithEntityName:@"Situation" predicate:nil sortDescriptors:descriptors fetchLimit:0];
  
  [descriptors release];
  [sortDescriptor release];
  
  return situations;
}

/**
 *  allCompletedQuestionnaireActions
 */
- (NSArray *)allCompletedQuestionnaireActions {
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"completionDate" ascending:NO];
  NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"completionDate != nil"] ;
  
  NSArray *actions = [self fetchManagedObjectsWithEntityName:@"QuestionnaireAction" predicate:predicate sortDescriptors:descriptors fetchLimit:0];
  
  [descriptors release];
  [sortDescriptor release];
  
  return actions;
}

/**
 *  rankForNextSession
 */
- (NSInteger)rankForNextSession {
  NSArray *sessions = [self allSessionsIncludingFinalSession:NO];
  NSInteger rank = 10; // 1 based so that it's friendlier in the UI.
  if ([sessions count] > 0) {
    Session *lastSession = [sessions lastObject];
    // Adjustment if we are running v1.1 code on an App with v1.0 data
    // (The ranks changed from 1,2,3... to 10, 20, 30....
    NSInteger lastRank = [lastSession.rank integerValue];
    if (lastRank < 10) lastRank = [sessions count] * 10;   // This is how it should look with v1.1 on...
    rank = lastRank + 10;
  }
  
  return rank;
}

/**
 *  assetForKey
 */
- (Asset *)assetForKey:(NSString *)key {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@", key];
  NSArray *objects = [self fetchManagedObjectsWithEntityName:@"Asset" predicate:predicate sortDescriptors:nil fetchLimit:1];
  
  return [objects lastObject];
}

/**
 *  insertNewActionWithValues
 */
- (Action *)insertNewActionWithValues:(NSDictionary *)values {
  return (Action *)[self insertNewObjectForEntityForName:@"Action" withValues:values];
}

/**
 *  insertNewQuestionWithValues
 */
- (Question *)insertNewQuestionWithValues:(NSDictionary *)values {
  return (Question *)[self insertNewObjectForEntityForName:@"Question" withValues:values];
}

/**
 *  insertNewQuestionnaireActionWithValues
 */
- (QuestionnaireAction *)insertNewQuestionnaireActionWithValues:(NSDictionary *)values {
  return (QuestionnaireAction *)[self insertNewObjectForEntityForName:@"QuestionnaireAction" withValues:values];
}

/**
 *  insertNewTextVideoActionWithValues
 */
- (TextVideoAction *)insertNewTextVideoActionWithValues:(NSDictionary *)values {
  return (TextVideoAction *)[self insertNewObjectForEntityForName:@"TextVideoAction" withValues:values];
}

/**
 *  insertNewAssetWithValues
 */
- (Asset *)insertNewAssetWithValues:(NSDictionary *)values {
  return (Asset *)[self insertNewObjectForEntityForName:@"Asset" withValues:values];
}

/**
 *  insertNewRecordingWithValues
 */
- (Recording *)insertNewRecordingWithValues:(NSDictionary *)values {
  return (Recording *)[self insertNewObjectForEntityForName:@"Recording" withValues:values];
}

/**
 *  insertNewScorecardWithValues
 */
- (Scorecard *)insertNewScorecardWithValues:(NSDictionary *)values {
  return (Scorecard *)[self insertNewObjectForEntityForName:@"Scorecard" withValues:values];
}

/**
 *  insertNewSessionWithValues
 */

- (Session *)insertNewSessionWithValues:(NSDictionary *)values {
  return (Session *)[self insertNewObjectForEntityForName:@"Session" withValues:values];
}

/**
 *  insertNewSessionWithSession
 */
- (Session *)insertNewSessionWithSession:(Session *)referenceSession {
  NSMutableDictionary *values = [NSMutableDictionary dictionaryWithCapacity:5];
  [values setObject:referenceSession.color forKey:@"color"];
  [values setObject:referenceSession.icon forKey:@"icon"];

  NSInteger rank = [[self allSessions] count];
  NSString *title = [NSString stringWithFormat:@"%@ %i", NSLocalizedString(@"Session", nil), rank];

  [values setObject:title forKey:@"title"];
  [values setObject:[NSNumber numberWithInteger:[[self allSessions] count]] forKey:@"rank"];
  
  Session *session = [self insertNewSessionWithValues:values];
  session.previousSession = referenceSession;
  session.nextSession = referenceSession.nextSession;
  referenceSession.nextSession = session;
  
  return  session;
}

/**
 *  insertNewSituationWithValues
 */

- (Situation *)insertNewSituationWithValues:(NSDictionary *)values {
  return (Situation *)[self insertNewObjectForEntityForName:@"Situation" withValues:values];
}

/**
 *  insertNewVisitWithValues
 */
- (Visit *)insertNewVisitWithValues:(NSDictionary *)values {
  return (Visit *)[self insertNewObjectForEntityForName:@"Visit" withValues:values];
}

/**
 *  insertNewObjectForEntityForName:withValues
 */
- (NSManagedObject *)insertNewObjectForEntityForName:(NSString *)entityName withValues:(NSDictionary *)valuesDictionary {
  NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
  [valuesDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [object setValue:[valuesDictionary valueForKey:key] forKey:key];
  }];
  
  return object;
} 

/**
 *  deleteObject
 */
- (void)deleteObject:(NSManagedObject *)object {
  [self.managedObjectContext deleteObject:object];
}

/**
 *  fetchManagedObjectsWithEntityName:predicate:sortDescriptors
 */
- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)fetchLimit {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  
  [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [fetchRequest setPredicate:predicate];
  
  NSError *error = nil;
  NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  
  if (fetchedObjects == nil) {
    // If there was an error, then just return an empty array.
    // (I'll probably regret this decision at some point down the road...)
    return [NSArray array];
  }
  
  return fetchedObjects;
}

@end
