//
//  Scorecard.h
//  PECoach
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;
@class Situation;
@class Recording;

@interface Scorecard : NSManagedObject {
}

// Attributes
@property(nonatomic, retain) NSDate *creationDate;
@property(nonatomic, retain) NSNumber *peakSUDSRating;
@property(nonatomic, retain) NSNumber *postSUDSRating;
@property(nonatomic, retain) NSNumber *preSUDSRating;

// Relationships
@property(nonatomic, retain) Recording *recording;
@property(nonatomic, retain) Session *session;
@property(nonatomic, retain) Situation *situation;

// Accessors
- (void)addScorecardsObject:(Scorecard *)value;
- (void)removeScorecardsObject:(Scorecard *)value;
- (void)addScorecards:(NSSet *)value;
- (void)removeScorecards:(NSSet *)value;

@end
