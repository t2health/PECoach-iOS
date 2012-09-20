//
//  Librarian.h
//  PECoach
//

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
