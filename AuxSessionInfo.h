//
//  AuxSessionInfo.h
//  PECoach
//
//  Created by Brian Doherty on 1/13/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

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
