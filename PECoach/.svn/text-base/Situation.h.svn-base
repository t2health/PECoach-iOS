//
//  Situation.h
//  PECoach
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;
@class Scorecard;

@interface Situation : NSManagedObject {

}

// Attributes
@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSNumber *finalSUDSRating;
@property (nonatomic, retain) NSNumber *initialSUDSRating;
@property (nonatomic, retain) NSString *title;

// Relationships
@property (nonatomic, retain) Session *nativeSession;
@property (nonatomic, retain) NSSet *scorecards;
@property (nonatomic, retain) NSSet *sessions;

// Accessors
- (void)addScorecardsObject:(Scorecard *)value;
- (void)removeScorecardsObject:(Scorecard *)value;
- (void)addScorecards:(NSSet *)value;
- (void)removeScorecards:(NSSet *)value;
- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end
