//
//  ContentLoader.h
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
