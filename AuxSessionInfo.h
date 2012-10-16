//
//  AuxSessionInfo.h
//  PECoach
//
//  Created by Brian Doherty on 1/13/12.
//  Copyright (c) 2012 T2. All rights reserved.
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

// Keep track of the Imaginal Exposure (since it can span multiple files)
#define kImaginalFileNameStart @"ImaginalFileNameStart"          // File name where the Imaginal recording starts
#define kImaginalFileNameEnd   @"ImaginalFileNameEnd"            // File name where the Imaginal recording ends
#define kNumberOfImaginalFiles @"NumberOfImaginalFiles"          // Total # of files the Imaginal recording spans
#define kImaginalExposureStartsOffset @"ImaginalExposureStartsOffset"
#define kImaginalExposureEndsOffset @"ImaginalExposureEndsOffset"

// Remember where the user was the last time they listened to the recording (so we can restart here)
#define kCurrentFileName        @"CurrentFileName"
#define kCurrentOffset          @"CurrentOffset"

@interface AuxSessionInfo : NSObject {
    // The filename of this plist
    NSString *pListFileName;
    
    // The data
    NSString *imaginalFileNameStart;
    NSString *imaginalFileNameEnd;
    NSNumber *numberOfImaginalFiles;
    NSNumber *imaginalExposureStartsOffset;
    NSNumber *imaginalExposureEndsOffset;
    NSString *currentFileName;
    NSNumber *currentOffset;
}

@property (copy, nonatomic) NSString *pListFileName;
@property (copy, nonatomic) NSString *imaginalFileNameStart;
@property (copy, nonatomic) NSString *imaginalFileNameEnd;
@property (copy, nonatomic) NSNumber *numberOfImaginalFiles;
@property (copy, nonatomic) NSNumber *imaginalExposureStartsOffset;
@property (copy, nonatomic) NSNumber *imaginalExposureEndsOffset;
@property (copy, nonatomic) NSString *currentFileName;
@property (copy, nonatomic) NSNumber *currentOffset;


- (NSString *)dataFilePath;         // Path to the Book plist (in the user's document folder)
- (BOOL)initPlist;                  // Initialization for this object
- (void)writeToPlist;               // Write out the current plist

@end
