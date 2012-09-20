//
//  QuestionnaireViewController.h
//  PECoach
//

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
