//
//  SUDSAnchorViewController.h
//  PECoach
//
//  Created by Brian Doherty on 5/31/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActionViewController.h"
#import "SUDSAnchors.h"

@interface SUDSAnchorViewController : ActionViewController <UITextFieldDelegate> {
    CGFloat keyBoardHeight;
    
    // SUDS Anchors
    SUDSAnchors *sudsAnchors;       
}

@property (copy, nonatomic) SUDSAnchors *sudsAnchors;

// Initializers
- (id)initWithSession:(Session *)session action:(Action *)action;

// UIActions
- (void)handleSaveButtonTapped:(id)sender;

@end
