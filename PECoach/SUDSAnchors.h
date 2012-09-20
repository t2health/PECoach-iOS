//
//  SUDSAnchors.h
//  
//
//  Created by Brian Doherty on 06/01/2012.
//  Copyright 2012 T2. All rights reserved.
//

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
