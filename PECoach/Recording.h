//
//  Recording.h
//  PECoach
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Scorecard;
@class Session;

@interface Recording : NSManagedObject {
}

// Attributes
@property (nonatomic, retain) NSNumber *imaginalExposureEndsOffset;
@property (nonatomic, retain) NSNumber *imaginalExposureStartsOffset;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSDate *creationDate;

// Relationships
@property (nonatomic, retain) NSSet *scorecards;
@property (nonatomic, retain) Session *session;

@end
