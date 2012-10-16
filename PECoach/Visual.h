//
//  Visual.h
//  Breathe
//
//  Created by Roger Reeder on 1/29/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
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


@interface Visual : NSObject {
	NSString	*name;
	NSString	*description;
	NSString	*bundleName;
	NSString	*postFix;
	NSString	*overlayFile;
	NSString	*backgroundFile;
	NSString	*thumbName;
	BOOL		staticImage;
	int			numberOfFrames;
	CGFloat		aspect;
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *bundleName;
@property(nonatomic, copy) NSString *postFix;
@property(nonatomic, copy) NSString *thumbName;
@property(nonatomic)	   BOOL staticImage;
@property(nonatomic, copy) NSString *overlayFile;
@property(nonatomic, copy) NSString *backgroundFile;
@property(nonatomic)	   int numberOfFrames;
@property(nonatomic)	   CGFloat aspect;

- (id)initWithName:(NSString *)n 
	   description:(NSString *)desc 
		bundleName:(NSString *)bundle
		   postFix:(NSString *)post 
	numberOfFrames:(int)frames 
	   overlayFile:(NSString *)overlay 
	   backgroundFile:(NSString *)background 
		 thumbName:(NSString *)thumb
	   staticImage:(BOOL)sImg;
@end
