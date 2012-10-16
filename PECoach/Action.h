//
//  Action.h
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
#import <CoreData/CoreData.h>

@class Session;
@class Visit;

@interface Action : NSManagedObject {
}

// Attributes
@property (nonatomic, assign) NSNumber *completed;
@property (nonatomic, retain) NSString *group;
@property (nonatomic, retain) NSString *homeworkTitle;
@property (nonatomic, retain) NSNumber *rank;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *type;

// Relationships
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) Action *parent;
@property (nonatomic, retain) Session *session;
@property (nonatomic, retain) NSSet *visits;

// Accessors
- (void)addChildrenObject:(Action *)value;
- (void)removeChildrenObject:(Action *)value;
- (void)addChildren:(NSSet *)value;
- (void)removeChildren:(NSSet *)value;
- (void)addVisitsObject:(Visit *)value;
- (void)removeVisitsObject:(Visit *)value;
- (void)addVisits:(NSSet *)value;
- (void)removeVisits:(NSSet *)value;

@end
