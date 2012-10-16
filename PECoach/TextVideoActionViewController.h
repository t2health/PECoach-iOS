//
//  TextVideoActionViewController.h
//  PECoach
//
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
#import "ActionViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ViewBCVideoController.h"

@class TextVideoAction;
@class Librarian;

@interface TextVideoActionViewController : ActionViewController  
                    <MFMailComposeViewControllerDelegate, ViewBCDelegate> {
  UIButton *videoButton_;
  UITextView *textView_;
  UILabel *urlLabel_;
    UIButton *urlButton_;
}

// Propertiers
@property(nonatomic, retain) UIButton *videoButton;
@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, retain) UILabel *urlLabel;
@property(nonatomic, retain) UIButton *urlButton;

// UI Actions
- (void)handleVideoButtonTapped:(id)sender;
- (void)handleUrlButtonTapped:(id)sender;
- (void)handleSegmentedControlTapped:(id)sender;

// Email methods
-(void)displayComposerSheet;

@end
