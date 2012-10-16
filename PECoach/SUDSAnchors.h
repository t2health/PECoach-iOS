//
//  SUDSAnchors.h
//  
//
//  Created by Brian Doherty on 06/01/2012.
//  Copyright 2012 T2. All rights reserved.
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

// Keys to the data in the plist
// Keys of the plist variables
#define kSUDSArray @"SUDSAnchorArray"       // Array containing the SUDS Anchors

// Keys of the SUDS Anchor Array
#define kAnchorValueKey @"SUDSAnchorValue"  // Key Name for an Anchor Value (0, 25, 50,...)
#define kAnchorDescKey @"SUDSAnchorDesc"    // Key Name for Anchor Description

@interface SUDSAnchors : NSObject {
    // The filename of the plist containing the data
    NSString *pListFileName;
    
    // This is where the contents of the plist goes
    NSMutableArray *sudsAnchorsArray; 
    
}

@property (copy, nonatomic) NSString *pListFileName;
@property (nonatomic, retain) NSMutableArray *sudsAnchorsArray;


- (NSString *)dataFilePath;         // Path to the Virtue plist (in the user's document folder)
- (void)initPlist;                  // Initialization for this object
- (void)writeToPlist;               // Write out the current plist

// Retrieve the SUDS Info
- (NSString *)valueForIndex :(NSInteger)index;     // Value
- (NSString *)descForIndex :(NSInteger)index;      // Description

// Save the SUDS Info
- (void)valueForIndex :(NSInteger)index value:(NSString *)newValue;     // Value
- (void)descForIndex :(NSInteger)index desc:(NSString *)newDesc;      // Description

// Formatted Data...
// Return all of the SUDS Anchors in a displayable string
- (NSString *)stringSUDSAnchors;


@end
