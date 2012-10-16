//
//  AuxSessionInfo.m
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
#import "AuxSessionInfo.h"

@implementation AuxSessionInfo

@synthesize pListFileName;
@synthesize imaginalFileNameStart;
@synthesize imaginalFileNameEnd;
@synthesize numberOfImaginalFiles;
@synthesize imaginalExposureStartsOffset;
@synthesize imaginalExposureEndsOffset;
@synthesize currentFileName;
@synthesize currentOffset;

// Construct the path to the plist file (in the documents folder)
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [[NSString alloc] initWithString:pListFileName];
    fileName  = [fileName stringByAppendingString:@".plist"];
    return [documentsDirectory stringByAppendingPathComponent:fileName]; 
}


// Initialize this object
- (BOOL)initPlist{
    //[Analytics logEvent:[NSString stringWithFormat:@"AUX SESSION INFO: %@",pListFileName]];
    
    // Read our data from the plist
    NSString *filePath = [self dataFilePath];
   
    // Make sure we have a file     
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        // Create a dictionary where we will load the data from the plist
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:filePath];
        
        // Read it in
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        
        if (!temp) {
            // This section intentionally left blank
        }
        
        // Only continue if we read the plist
        if (temp) {
            // OK...let's process what we got
            
            // Grab the File name (or starting file if there are multiple files)
            self.imaginalFileNameStart = [temp objectForKey:kImaginalFileNameStart]; 
            self.imaginalFileNameEnd = [temp objectForKey:kImaginalFileNameEnd];   
            
            // # of Imaginal files being used 
            self.numberOfImaginalFiles = [temp objectForKey:kNumberOfImaginalFiles];  
            
            // And the start and end times
            self.imaginalExposureStartsOffset = [temp objectForKey:kImaginalExposureStartsOffset];
            self.imaginalExposureEndsOffset = [temp objectForKey:kImaginalExposureEndsOffset];
            
            // Current position
            self.currentFileName = [temp objectForKey:kCurrentFileName];
            self.currentOffset = [temp objectForKey:kCurrentOffset];
        }
    }
    else {
        // AuxSessionInfo File does not exist
        return FALSE;
    }
    
    return TRUE;
    
}

- (void)writeToPlist
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    // Set the values for each of our keys
    if (numberOfImaginalFiles != nil) 
        [data setObject:numberOfImaginalFiles forKey:kNumberOfImaginalFiles];
    if (imaginalFileNameStart != nil)
        [data setObject:imaginalFileNameStart forKey:kImaginalFileNameStart];
    if (imaginalFileNameEnd != nil)
        [data setObject:imaginalFileNameEnd forKey:kImaginalFileNameEnd];
    if (imaginalExposureStartsOffset != nil)
        [data setObject:imaginalExposureStartsOffset forKey:kImaginalExposureStartsOffset];
    if (imaginalExposureEndsOffset != nil)
        [data setObject:imaginalExposureEndsOffset forKey:kImaginalExposureEndsOffset];
    if (currentFileName != nil)
        [data setObject:currentFileName forKey:kCurrentFileName];
    if (currentOffset != nil)
        [data setObject:currentOffset forKey:kCurrentOffset];
        
    [data writeToFile:[self dataFilePath] atomically:YES];
    [data release];    
}

- (void)dealloc {
    [pListFileName release];
    [imaginalFileNameStart release];
    [imaginalFileNameEnd release];
    [numberOfImaginalFiles release];
    [imaginalExposureStartsOffset release];
    [imaginalExposureEndsOffset release];
    [currentOffset release];
    [currentFileName release];
    [super dealloc];
}

@end
