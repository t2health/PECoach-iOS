//
//  SUDSAnchors.m
//  
//  Utilize a plist to provide structure, control and tracking of 
//  the SUDS Anchors.   These are milestone SUDS valeus that are 
//  given a description by the patient so that they can easily
//  relate the number to an emotion they experience.
//
//  The plist has the following format (subject to revision!):
//      Key                 Value
//      =========           =========================
//      SUDS Anchors        <array> of entries for each SUDS value/desc in the array
//          Value           String representation of a number (0, 25, 50...)
//          Desc            String description of corresponding number
//
//  Created by Brian Doherty on 06/01/2012.
//  Copyright 2012 T2 All rights reserved.
//

#import "SUDSAnchors.h"
//#import "Analytics.h"


@implementation SUDSAnchors

@synthesize pListFileName;
@synthesize sudsAnchorsArray;


// Construct the path to the plist file (in the documents folder)
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [[[NSString alloc] initWithString:pListFileName] autorelease];
    fileName  = [fileName stringByAppendingString:@".xml"];
    return [documentsDirectory stringByAppendingPathComponent:fileName]; 
}

// Initialize this object
- (void)initPlist{
    //[Analytics logEvent:[NSString stringWithFormat:@"BOOK PLIST: %@",pListFileName]];
    
    // Read our data from the plist
    NSString *filePath = [self dataFilePath];
    
    // We first try to find it in our App directory (the updated version)
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // Doesn't exist in our App directory...use the original one in the bundle
        filePath = [[NSBundle mainBundle] pathForResource:pListFileName ofType:@"xml"];
    }
    
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
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        // Only continue if we read the plist
        if (temp) {
            // OK...let's process what we got
                                   
            // Get a copy of all of the SUDS Anchors
            sudsAnchorsArray = [NSMutableArray arrayWithArray:[temp objectForKey:kSUDSArray ]]; 
            [self.sudsAnchorsArray retain];

        }
    }
    
}


// Retrieve the SUDS Anchor Info
- (NSString *)valueForIndex :(NSInteger)index {             // SUDS Value
    NSDictionary *myElement = [sudsAnchorsArray objectAtIndex:index];
    return [myElement objectForKey:kAnchorValueKey];
}
- (NSString *)descForIndex :(NSInteger)index {              // SUDS Description
    NSDictionary *myElement = [sudsAnchorsArray objectAtIndex:index];
    return [myElement objectForKey:kAnchorDescKey];
}

// Save the SUDS Anchor Info
- (void)valueForIndex :(NSInteger)index value:(NSString *)newValue {
    NSDictionary *myElement = [sudsAnchorsArray objectAtIndex:index];  // Get the element
    [myElement setObject:newValue forKey:kAnchorValueKey];
    
    [self writeToPlist];
}
- (void)descForIndex :(NSInteger)index desc:(NSString *)newDesc{
    
    NSDictionary *myElement = [sudsAnchorsArray objectAtIndex:index];  // Get the element
    [myElement setObject:newDesc forKey:kAnchorDescKey];
    
    [self writeToPlist];
}


// Return all of the SUDS Anchors in a displayable string
- (NSString *)stringSUDSAnchors {
    
    NSString *returnString = [[NSString alloc] initWithString:@""];
    
    // Grab each value/desc pair and create the string
    for (int i=0;i<5;i++) {
        returnString = [returnString stringByAppendingFormat:@"%@\t\t\t%@\n",[self valueForIndex:i],[self descForIndex:i]];
    }
    
    // Add an info message
    returnString = [returnString stringByAppendingFormat:@"\n(Tap to dismiss)"];
    
    return returnString;
}

- (void)writeToPlist
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setObject:sudsAnchorsArray  forKey:kSUDSArray];   // Write everything in the SUDS Anchor array
        
    [data writeToFile:[self dataFilePath] atomically:YES];
    [data release];    
}

- (void)dealloc {;
    [pListFileName release];
    [sudsAnchorsArray release];
    [super dealloc];
}
@end
