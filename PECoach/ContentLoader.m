//
//  ContentLoader.m
//  PECoach
//

#import "ContentLoader.h"
#import "Action.h"
#import "Asset.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "Question.h"
#import "QuestionnaireAction.h"
#import "Session.h"
#import "TextVideoAction.h"
#import "UIColor+PEColor.h"

@implementation ContentLoader

#pragma mark - Properties

@synthesize includesDictionary = includesDictionary_;
@synthesize librarian = librarian_;

#pragma mark - Lifecycle

/**
 *  initWithLibrarian
 */
- (id)initWithLibrarian:(Librarian *)librarian {
  self = [self init];
  if (self != nil) {
    librarian_ = [librarian retain];
    includesDictionary_ = [[NSMutableDictionary alloc] initWithCapacity:10];
  }
  
  return self;
}

/**
 *  dealloc
 */
- (void)dealloc {
  [librarian_ release];
  [includesDictionary_ release];
  
  [super dealloc];
}

#pragma mark - Instance Methods

/**
 *  loadContent
 */
- (void)loadContent {
  TBXML *tbxml = [TBXML tbxmlWithXMLFile:kApplicationContentPath];
  TBXMLElement *rootXMLElement = tbxml.rootXMLElement;
  
  if (rootXMLElement != nil) {    
    NSString *contentVersion = [TBXML valueOfAttributeNamed:@"version" forElement:rootXMLElement];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *installedVersion = [userDefaults objectForKey:kUserDefaultsKeyContentVersion];
    
    if ([installedVersion isEqualToString:contentVersion] == NO) {
      NSFileManager *fileManager = [NSFileManager defaultManager];
      [fileManager removeItemAtURL:self.librarian.persistentStoreURL error:nil];
    
      // Includes must be loaded first.
      TBXMLElement *includesElement = [TBXML childElementNamed:@"includes" parentElement:rootXMLElement];
      if (includesElement != nil) {
        [self loadIncludesFromXMLElement:includesElement];
      }

      // Load Assets
      TBXMLElement *assetsElement = [TBXML childElementNamed:@"assets" parentElement:rootXMLElement];
      if (assetsElement != nil) {
        [self loadAssetsFromXMLElement:assetsElement];
      }
      
      // Load Sessions
      TBXMLElement *sessionsElement = [TBXML childElementNamed:@"sessions" parentElement:rootXMLElement];
      if (sessionsElement != nil) {
        [self loadSessionsFromXMLElement:sessionsElement];
      }
      
      [userDefaults setObject:contentVersion forKey:kUserDefaultsKeyContentVersion];
      [userDefaults synchronize];
    }
  }
  
  [self.librarian save];
}

/**
 *  loadSessionFromTemplate
 */
- (void)loadSessionFromTemplate:(NSString *)assetKey {
  TBXML *tbxml = [TBXML tbxmlWithXMLFile:kApplicationContentPath];
  TBXMLElement *rootXMLElement = tbxml.rootXMLElement;
  
  if (rootXMLElement != nil) {
    // Includes must be loaded first.
    TBXMLElement *includesElement = [TBXML childElementNamed:@"includes" parentElement:rootXMLElement];
    if (includesElement != nil) {
      [self loadIncludesFromXMLElement:includesElement];
    }

    // Find the Asset that contains the session template, then load that through a new TBXML parser.
      Asset *sessionTemplate = [self.librarian assetForKey:assetKey];  // kAssetKeySessionTemplate];
    TBXML *templateTBXML = [TBXML tbxmlWithXMLString:sessionTemplate.content];
    TBXMLElement *templateRootElement = templateTBXML.rootXMLElement;
      
    // Colors need to cycle between those colors set in the first four sessions
    UIColor *color = nil;
    UIColor *subTitleColor = nil;
    NSString *icon = nil;
    
    NSArray *sessions = [self.librarian allSessionsIncludingFinalSession:NO];
    NSUInteger sessionsCount = [sessions count];
      
      // Figure out if this is Session 2 or 2A (or 2B)....we will need these values a couple of times
      // Ok...a little overkill here but it allows for conciseness below
      BOOL bIsThisSession2or2A = ([assetKey isEqualToString:kAssetKeySessionTemplateSession2] || 
                              [assetKey isEqualToString:kAssetKeySessionTemplateSession2A]);
      BOOL bIsThisSession2 = (bIsThisSession2or2A || 
                              [assetKey isEqualToString:kAssetKeySessionTemplateSession2B]);
      BOOL bIsThisSession2B = [assetKey isEqualToString:kAssetKeySessionTemplateSession2B];
      
      // Skip this if we are creating Session 2...we know what color that should be
      if (!bIsThisSession2) {
          // Create the colors for all other new sessions
          // TBD - If we created a 2 part Session 2, the indexing numbers might be off below...check it out!
        if (sessionsCount > 0) {
          NSUInteger referenceIndex = MIN(sessionsCount % 4, sessionsCount - 1);
          Session *referenceSession = [sessions objectAtIndex:referenceIndex];
          color = referenceSession.color;
          subTitleColor = referenceSession.subTitleColor;
          icon = referenceSession.icon;
        }
      }

   
      
      // Determine the Rank for this session
      int myRank = 0;           // 0 - Allow Librarian to assign the next rank (default)
      
      if (bIsThisSession2or2A) myRank = 25;
      if (bIsThisSession2B) myRank = 21;
                
      Session *session = [self sessionFromXMLElement:templateRootElement rank:myRank];  // Create the new session
      
    // Title...don't want the rank in the title if we are adding Session 2 (or 2A or 2B)  
      if (bIsThisSession2) {
          session.title = [NSString stringWithFormat:@"%@", session.title];
      } else {
          session.title = [NSString stringWithFormat:@"%@ %d", session.title, [session.rank intValue]/10];  // Drop Unit '0' from name
      }
      
      // Now put this new session in its proper place
      if (bIsThisSession2) {
          // Session 2, 2A or 2B....basically its going to be after #1 and before #3 !!!
          // But since there can be 2A and 2B...it gets a little more involved....
          Session *firstSession = [sessions objectAtIndex:0];   
          Session *secondSession = firstSession.nextSession;
          Session *thirdSession = secondSession.nextSession;
          
          // If this is 2 or 2A...we will just replace the temporary session 2
          // (Note: the old session 2 is still hanging around...we just don't use it anymore...is that ok?)
          if (bIsThisSession2or2A) {
              firstSession.nextSession = session;
              session.nextSession = thirdSession;
          } else {
              // If this is 2B...we will place this in front of the third session
              secondSession.nextSession = session;
              session.nextSession = thirdSession;     // Let's look at the array of sessions
              
          }
      } else {
          // For 'normal' end of the line adds...follow this logic
          Session *lastSession = [sessions lastObject];
          Session *nextSession = lastSession.nextSession;
          
          session.previousSession = lastSession;
          session.nextSession = nextSession;
          lastSession.nextSession = session;
      }
     

      // And set its color
    if (color != nil && icon != nil) {
      session.color = color;
      session.subTitleColor = subTitleColor;
      session.icon = icon;
    }
    
      // TBD .... make an adjustment here if we add 2A and 2B...we'll need to reverse this check!
    // This is a bit weird, but we only include the Questionnaire action in odd-numbered
    // sessions. Since the Questionnaire action is always part of the XML template, we
    // need to manually remove the Questionnaire for even-numbered sessions. 
    if (  ((([session.rank integerValue]/10) % 2) == 0) && !bIsThisSession2) {
      [[session actionsForGroup:kActionGroupTasks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Action *action = (Action *)obj;
        if ([action.type isEqualToString:kActionTypeQuestionnaire] == YES) {
          [self.librarian deleteObject:action];
          *stop = YES;
        }
      }];
    }
      
    // If we just added Session 2B, then we want to remove 'Common Reactions to Trauma' from Session 3 Toolbox
      if (bIsThisSession2B) {
          // Find Session 3   
          NSEnumerator *e = [sessions objectEnumerator];
          id object;
          while (object = [e nextObject]) {
              Session *mySession = (Session *)object;
              //NSLog(@"title:%@  rank:%@",mySession.title,mySession.rank);
              if ([mySession.rank integerValue] == 30) {    // Ranks are 10, 20, 30 etc (except for 2A/2B as seen above)
                  // Now find 'Common Reactions to Trauma'
                  [[session actionsForGroup:kActionGroupToolbox] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                      Action *action = (Action *)obj;
                      if ([action.type isEqualToString:kActionTypeParent] == YES) {
                          // Finally check the title
                          //NSLog(@"Action Title: %@",action.title);
                          if ([action.title isEqualToString:@"Common Reactions to Trauma"] == YES) {
                              //NSLog(@"...deleting the action: %@",action.title);
                              [self.librarian deleteObject:action];         // Delete it
                              *stop = YES;
                          }
                      }
                  }];
              }
          }
      }
      
  }
  
  [self.librarian save];
}

/**
 *  loadAssetsFromXMLElement
 */
- (void)loadAssetsFromXMLElement:(TBXMLElement *)element {
  TBXMLElement *assetElement = [TBXML childElementNamed:@"asset" parentElement:element];
  
  while (assetElement != nil) {
    [self assetFromXMLElement:assetElement];
    assetElement = [TBXML nextSiblingNamed:@"asset" searchFromElement:assetElement];
  }
}

/**
 *  loadIncludesFromXMLElement
 */
- (void)loadIncludesFromXMLElement:(TBXMLElement *)element {
  TBXMLElement *includeElement = [TBXML childElementNamed:@"include" parentElement:element];
    
  while (includeElement != nil) {
    NSString *includeElementKey = [TBXML valueOfAttributeNamed:@"key" forElement:includeElement];
    NSString *includeElementText = [TBXML textForElement:includeElement];
    
    // There doesn't appear to be a way to have TBXML return us the entire XML node as text,
    // so we have to recreate it here for future parsing. Yes, this is a hack as is the 
    // need to wrap the include elements in CDATA sections... Sorry.
    NSString *includeXML = [[NSString alloc] initWithFormat:@"<include key=\"%@\">%@</include>", includeElementKey, includeElementText];
    [self.includesDictionary setValue:includeXML forKey:includeElementKey];
    [includeXML release];
    
    includeElement = [TBXML nextSiblingNamed:@"include" searchFromElement:includeElement];
  }
}

/**
 *  loadSessionsFromXMLElement
 */
- (void)loadSessionsFromXMLElement:(TBXMLElement *)element {
  TBXMLElement *sessionElement = [TBXML childElementNamed:@"session" parentElement:element];
  Session *previousSession = nil;
  
  while (sessionElement != nil) {
      Session *session = [self sessionFromXMLElement:sessionElement rank:0];
    session.previousSession = previousSession;
    previousSession = session;
    
    sessionElement = [TBXML nextSiblingNamed:@"session" searchFromElement:sessionElement];
  }
}

/**
 *  actionFromXMLElement
 */
- (Action *)actionFromXMLElement:(TBXMLElement *)element session:(Session *)session parent:(Action *)parent rank:(NSUInteger)rank {
  NSString *actionType = [TBXML valueOfAttributeNamed:@"type" forElement:element];
  
  // This is a rather long-winded way of populating actionValues, but we can't use the convenience
  // constructors on NSMutableDictionary because some of these attributes might return nil and 
  // would thus be interpretted as a terminating nil.
  NSMutableDictionary *actionValues = [[NSMutableDictionary alloc] initWithCapacity:3];
  [actionValues setValue:actionType forKey:@"type"];
  [actionValues setValue:[TBXML valueOfAttributeNamed:@"homeworkTitle" forElement:element] forKey:@"homeworkTitle"];
  [actionValues setValue:[TBXML valueOfAttributeNamed:@"title" forElement:element] forKey:@"title"];
  [actionValues setValue:[TBXML valueOfAttributeNamed:@"group" forElement:element] forKey:@"group"];
  [actionValues setValue:[NSNumber numberWithUnsignedInteger:rank] forKey:@"rank"];
  
  Action *action = nil;
  
  if ([actionType isEqualToString:kActionTypeTextVideo]) {
    // For TextVideoActions, see if there's a 'text' attribute that represents the
    // Asset key where we'll find the actual text for this action. 
    NSString *textKey = [TBXML valueOfAttributeNamed:@"text" forElement:element];
    Asset *textAsset = [self.librarian assetForKey:textKey];
    
    // Remove the tab indentation that is present in the XML file. Likely a much smarter way to do this....
    NSString *tabFree = [textAsset.content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    [actionValues setValue:tabFree forKey:@"text"];
    
    NSString *videoKey = [TBXML valueOfAttributeNamed:@"video" forElement:element];
    Asset *videoAsset = [self.librarian assetForKey:videoKey];
    [actionValues setValue:videoAsset.content forKey:@"videoPath"];
      
    // Add url
    NSString *urlKey = [TBXML valueOfAttributeNamed:@"url" forElement:element];
    Asset *urlAsset = [self.librarian assetForKey:urlKey];
    [actionValues setValue:urlAsset.content forKey:@"url"];
      
    action = [self.librarian insertNewTextVideoActionWithValues:actionValues];
    
  } else if ([actionType isEqualToString:kActionTypeQuestionnaire]) {
    action = [self.librarian insertNewQuestionnaireActionWithValues:actionValues];
    NSArray *questions = [self questionsFromQuestionnaireElement:element];
    [(QuestionnaireAction *)action setQuestions:[NSSet setWithArray:questions]];
  } else if ([actionType isEqualToString:kActionTypeParent]) {
    action = [self.librarian insertNewActionWithValues:actionValues];

    NSString *includeKey = [TBXML valueOfAttributeNamed:@"include" forElement:element];
    NSString *includeXML = [self.includesDictionary objectForKey:includeKey];
    
    // Rather annoying that we have to create an entirely new TBXML parser to handle the include element.
    // Unfortunately, there doesn't appear to be a way to inject this XML back in to the existing parser. 
    TBXML *tbxml = [TBXML tbxmlWithXMLString:includeXML];
    TBXMLElement *includeRootElement = tbxml.rootXMLElement;
    
    if (includeRootElement != nil) {
      TBXMLElement *childActionElement = [TBXML childElementNamed:@"action" parentElement:includeRootElement];
      NSUInteger childActionRank = 0;
      
      while (childActionElement != nil) {
        [self actionFromXMLElement:childActionElement session:session parent:action rank:childActionRank];

        childActionRank += 1;
        childActionElement = [TBXML nextSiblingNamed:@"action" searchFromElement:childActionElement];
      }
    } 
  } else if ([actionType isEqualToString:kActionTypeWebView]) {
      // We are doing nothing right now for this Web View
      // It is hard coded to go to a particular website
      // But if we ever want to go to multiple websites...this is where we could do that
      action = [self.librarian insertNewActionWithValues:actionValues];
  } else {
    action = [self.librarian insertNewActionWithValues:actionValues];
  }
  
  action.session = session;
  action.parent = parent;
  
  [actionValues release];

  return action;
}

/**
 *  assetFromXMLElement
 */
- (Asset *)assetFromXMLElement:(TBXMLElement *)element {
  NSDictionary *assetValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                               [TBXML valueOfAttributeNamed:@"key" forElement:element], @"key", 
                               [TBXML textForElement:element], @"content", nil];
  
  return (Asset *)[self.librarian insertNewAssetWithValues:assetValues];
}

/**
 *  questionsFromQuestionnaireElement
 */
- (NSArray *)questionsFromQuestionnaireElement:(TBXMLElement *)element {
  NSString *includeKey = [TBXML valueOfAttributeNamed:@"include" forElement:element];
  NSString *includeXML = [self.includesDictionary objectForKey:includeKey];
  NSMutableArray *questions = [NSMutableArray arrayWithCapacity:20];

  TBXML *tbxml = [TBXML tbxmlWithXMLString:includeXML];
  TBXMLElement *rootElement = tbxml.rootXMLElement;
  
  if (rootElement != nil) {
    TBXMLElement *questionElement = [TBXML childElementNamed:@"question" parentElement:rootElement];

    // Note that rank starts at one so that it's a bit more user friendly in the UI.
    NSUInteger rank = 1;
    
    while (questionElement != nil) {
      NSDictionary *values = [[NSDictionary alloc] initWithObjectsAndKeys:[TBXML textForElement:questionElement], @"text", 
                                                                          [NSNumber numberWithUnsignedInteger:rank], @"rank", nil];
      
      Question *question = [self.librarian insertNewQuestionWithValues:values];
      [questions addObject:question];
      [values release];
      
      rank += 1;
      questionElement = [TBXML nextSiblingNamed:@"question" searchFromElement:questionElement];
    }
  } 
  
  return questions;
}

/**
 *  sessionFromXMLElement
 */
- (Session *)sessionFromXMLElement:(TBXMLElement *)element rank:(int)rank{
  UIColor *sessionColor = [UIColor colorWithRGBString:[TBXML valueOfAttributeNamed:@"color" forElement:element]];
  UIColor *subTitleColor = [UIColor colorWithRGBString:[TBXML valueOfAttributeNamed:@"subTitleColor" forElement:element]];
    NSNumber *sessionRank;
     
    // If rank == 0, get the next rank...otherwise use rank for this session
    if (rank == 0) {
        sessionRank = [NSNumber numberWithInteger:[self.librarian rankForNextSession]];
    } else {
        sessionRank = [NSNumber numberWithInt:rank];
    }
    

  if ([[TBXML valueOfAttributeNamed:@"order" forElement:element] isEqualToString:@"last"] == YES) {
    sessionRank = [NSNumber numberWithInteger:NSIntegerMax];
  }
  
  NSDictionary *sessionValues = [NSDictionary dictionaryWithObjectsAndKeys:[TBXML valueOfAttributeNamed:@"title" forElement:element], @"title", 
                                                                           [TBXML valueOfAttributeNamed:@"icon" forElement:element], @"icon",
                                                                            sessionColor, @"color", 
                                                                            subTitleColor, @"subTitleColor",
                                                                            sessionRank, @"rank", nil];
  
  Session *session = [self.librarian insertNewSessionWithValues:sessionValues];
  
  TBXMLElement *actionElement = [TBXML childElementNamed:@"action" parentElement:element];
  NSUInteger actionRank = 0;
  
  while (actionElement != nil) {
    [self actionFromXMLElement:actionElement session:session parent:nil rank:actionRank];
    
    actionRank += 1;
    actionElement = [TBXML nextSiblingNamed:@"action" searchFromElement:actionElement];
  }
  
  return session;
}

@end
