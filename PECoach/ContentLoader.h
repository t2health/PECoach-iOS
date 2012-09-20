//
//  ContentLoader.h
//  PECoach
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@class Action;
@class Asset;
@class Librarian;
@class Session;

@interface ContentLoader : NSObject {
  NSMutableDictionary *includesDictionary_;
  Librarian *librarian_;
  
  BOOL removeOldStore_;
}

// Properties
@property(nonatomic, retain) NSMutableDictionary *includesDictionary;
@property(nonatomic, retain) Librarian *librarian;

// Initializers
- (id)initWithLibrarian:(Librarian *)librarian;

// Instance Methods
- (void)loadContent;
- (void)loadSessionFromTemplate:(NSString *)assetKey;

- (void)loadAssetsFromXMLElement:(TBXMLElement *)element;
- (void)loadIncludesFromXMLElement:(TBXMLElement *)element;
- (void)loadSessionsFromXMLElement:(TBXMLElement *)element;

- (Action *)actionFromXMLElement:(TBXMLElement *)element session:(Session *)session parent:(Action *)action rank:(NSUInteger)rank;
- (Asset *)assetFromXMLElement:(TBXMLElement *)element;
- (NSArray *)questionsFromQuestionnaireElement:(TBXMLElement *)element;
- (Session *)sessionFromXMLElement:(TBXMLElement *)element rank:(int)rank;

@end
