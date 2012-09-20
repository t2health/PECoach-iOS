//
//  Session.h
//  PECoach
//

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
