//
//  Asset.h
//  PECoach
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Asset : NSManagedObject {
}

// Attributes
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *content;

@end
