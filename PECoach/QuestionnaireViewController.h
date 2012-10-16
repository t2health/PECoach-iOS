//
//  QuestionnaireViewController.h
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
#import "ActionTableViewController.h"

@class Question;

@interface MyCell : UITableViewCell {

}
@end

@interface QuestionnaireViewController : ActionTableViewController<UIAlertViewDelegate> {
  // Navigation through the questions  
  UIButton *previousButton_;
  UIButton *nextButton_;
  UIPageControl *pageControl_;
    
  // The actual questions  
  NSArray *questions_;
  NSIndexPath *lastSelectedIndexPath_;
  Question *currentQuestion_;
  BOOL bOnlyUnansweredQuestions;  
    
    // Accessibility (helps VoiceOver say the relevant hints)
    NSString *currentHint;
    NSString *questionLabels;
    NSString *answerLabels;
    NSString *instructionsTitle;
    NSString *instructionsText;
    NSString *instructionsDismiss;
    BOOL    firstQuestion;
    
}

// Properties
@property(nonatomic, retain) UIButton *previousButton;
@property(nonatomic, retain) UIButton *nextButton;
@property(nonatomic, retain) UIPageControl *pageControl;
@property(nonatomic, retain) NSArray *questions;
@property(nonatomic, retain) NSIndexPath *lastSelectedIndexPath;
@property(nonatomic, retain) Question *currentQuestion;
@property(nonatomic, assign) BOOL bOnlyUnansweredQuestions;
@property(nonatomic, retain) NSString *questionLabels;
@property(nonatomic, retain) NSString *answerLabels;
@property(nonatomic, retain) NSString *currentHint;
@property(nonatomic, retain) NSString *instructionsTitle;
@property(nonatomic, retain) NSString *instructionsText;
@property(nonatomic, retain) NSString *instructionsDismiss;
@property(nonatomic, assign) BOOL bFirstQuestion;

// Instance Methods
- (UIView *)headerViewForQuestion:(Question *)question;
- (void)pressNextQuestion;
- (void)pressPreviousQuestion;
- (void)loadNextQuestion;
- (void)loadPreviousQuestion;
- (void)loadQuestionAtIndex:(NSUInteger)index;
- (void)findFirstUnansweredQuestion;
- (void)timerReset;

@end
