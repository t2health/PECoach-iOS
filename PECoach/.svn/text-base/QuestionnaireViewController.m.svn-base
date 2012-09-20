//
//  QuestionnaireViewController.m
//  PECoach
//

#include <QuartzCore/QuartzCore.h>
#import "QuestionnaireViewController.h"
#import "CompletedQuestionnaireViewController.h"
#import "QuestionnairesReviewActionViewController.h"
#import "PECoachConstants.h"
#import "QuestionnaireAction.h"
#import "Question.h"
#import "Session.h"
#import "UILabel+PELabel.h"
#import "UIView+Positionable.h"
#import "Analytics.h"
#import "MKInfoPanel.h"

static NSArray *sPossibleAnswers;

// Subclass UITableViewCell to accomodate Accessibility
@implementation MyCell: UITableViewCell

- (void)accessibilityElementDidBecomeFocused {
    
    // Change the accessibility info for this question        
    NSString *newQlabel = [NSString stringWithFormat:@"%@, %@", 
                           self.textLabel.text, NSLocalizedString(@",Answer Option Button", "nil")];
    [self setAccessibilityLabel:newQlabel];
}

- (void)accessibilityElementDidLoseFocus {
    // NSLog(@"accessibilityElementDidLoseFocus %@",self.textLabel.text);
    //BOOL isIt = [cell accessibilityElementIsFocused];
    //NSLog(@"Is cell Focused: %@",isIt?@"TRUE":@"FALSE");
}

@end


@implementation QuestionnaireViewController

#pragma mark - Properties

@synthesize previousButton = previousButton_;
@synthesize nextButton = nextButton_;
@synthesize pageControl = pageControl_;
@synthesize questions = questions_;
@synthesize lastSelectedIndexPath = lastSelectedIndexPath_;
@synthesize currentQuestion = currentQuestion_;
@synthesize bOnlyUnansweredQuestions = bOnlyUnansweredQuestions_;
@synthesize questionLabels = questionLabels_;
@synthesize answerLabels = answerLabels_;
@synthesize currentHint = currentHint_;
@synthesize instructionsTitle = instructionsTitle_;
@synthesize instructionsText = instructionsText_;
@synthesize instructionsDismiss = instructionsDismiss_;
@synthesize bFirstQuestion;

#pragma mark - Class Methods

/**
 *  initialize
 */
+ (void) initialize {
  if (sPossibleAnswers == nil) {
    NSMutableArray *answers = [[NSMutableArray alloc] initWithCapacity:5];
    
    // Don't set an answer's value to '0' as that's the default value for Question.answer and will result in undefined behavior.
    [answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Not at all", @""), @"title", [NSNumber numberWithInt:1], @"value", nil]];
    [answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"A little bit", @""), @"title", [NSNumber numberWithInt:2], @"value", nil]];
    [answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Moderately", @""), @"title", [NSNumber numberWithInt:3], @"value", nil]];
    [answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Quite a bit", @""), @"title", [NSNumber numberWithInt:4], @"value", nil]];
      [answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Extremely", @""), @"title", [NSNumber numberWithInt:5], @"value", nil]];
      
    sPossibleAnswers = [answers copy];
    [answers release];
  }

    
}


#pragma mark - Voice Over
- (void) receiveAccessibilityNotification:(NSNotification *) notification
{
    //NSLog(@"Accessibility Notification received");
    // This is a no-op for now, but is left here if we need to modify Accessibility in the future
}

#pragma mark - Lifecycle

/**
 *  initWithSession:action
 */
- (id)initWithSession:(Session *)session action:(Action *)action {
  self = [super initWithSession:session action:action];
  if (self != nil) {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES];
    questions_ = [[((QuestionnaireAction *)self.action).questions sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]] retain];
  }
    
    // Specify localized text that is used in mulitple locations (avoid duplication)
    [self setInstructionsTitle:NSLocalizedString(@"Instructions",nil)];
    [self setInstructionsText:NSLocalizedString(@"Following is a list of problems and complaints that people sometimes have in response to stressful life experiences.  Please read each one carefully, then 'tap' the response that best indicates how much you have been bothered by that problem IN THE PAST MONTH.",nil)];
    [self setInstructionsDismiss:NSLocalizedString(@"Double tap to dismiss instructions,,,",nil)];
    bFirstQuestion = false;
    
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
    

  CGSize buttonSize = CGSizeMake(30.0, 44.0);
  CGFloat yOrigin = (self.infoView.frame.size.height - buttonSize.height) / 2;
    
    CGRect labelFrame = self.infoLabel.frame;
    labelFrame.size.width = self.infoView.frame.size.width - (buttonSize.width * 5);  // Should be '*2' but we need more room for the buttons
    labelFrame.origin.x = 5;        // And position this near the left edge
    
    self.infoLabel.frame = labelFrame;
    //[self.infoLabel positionToTheLeftOfView:self.view  margin:0.0];
    
  // Previous question button
  UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
  previousButton.frame = CGRectMake(0.0, yOrigin, buttonSize.width, buttonSize.height);
  [previousButton setImage:[UIImage imageNamed:@"previousQuestion.png"] forState:UIControlStateNormal];
  [previousButton addTarget:self action:@selector(pressPreviousQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    //[previousButton centerHorizontallyInView:self.infoLabel];
    [previousButton positionToTheRightOfView:self.infoLabel margin:-20.0];
  [self.infoView addSubview:previousButton];
  self.previousButton = previousButton;
  

  // Next question button
  UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
  nextButton.frame = CGRectMake(0.0, yOrigin, buttonSize.width, buttonSize.height);
  [nextButton setImage:[UIImage imageNamed:@"nextQuestion.png"] forState:UIControlStateNormal];
  [nextButton addTarget:self action:@selector(pressNextQuestion) forControlEvents:UIControlEventTouchUpInside];
  
  [nextButton positionToTheRightOfView:self.previousButton margin:5.0];  // 20.0
  [self.infoView addSubview:nextButton];
  self.nextButton = nextButton;

  // Page control
  CGRect pageRect = CGRectMake(0, self.infoView.frame.size.height - 13, self.infoView.frame.size.width, 13);
  UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:pageRect];
  pageControl.numberOfPages = [self.questions count];
  pageControl.defersCurrentPageDisplay = YES;
  self.pageControl = pageControl;
  [pageControl release];
  
  [self.infoView addSubview:pageControl];
  
  // Show all of the questions...not just the unanswered ones  
  self.bOnlyUnansweredQuestions = NO;  

  self.lastSelectedIndexPath = nil;
  self.currentQuestion = nil;
  [self loadNextQuestion];
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.previousButton = nil;
  self.nextButton = nil;
  self.pageControl = nil;
  self.lastSelectedIndexPath = nil;
    self.currentHint = nil;
    self.questionLabels = nil;
    self.answerLabels = nil;
  
  [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    // We are leaving...
    // Make sure we are out of 'unanswered' question mode
    self.bOnlyUnansweredQuestions = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"QUESTIONNAIRE VIEW"];
    [super viewDidAppear:animated];
}


/**
 *  dealloc
 */
- (void)dealloc {
  [previousButton_ release];
  [nextButton_ release];
  [pageControl_ release];
  [questions_ release];
  [lastSelectedIndexPath_ release];
  [currentQuestion_ release];
    [currentHint_ release];
    [questionLabels_ release];
    [answerLabels_ release];
  
  [super dealloc];
}

#pragma mark - UITableViewDataSource Methods

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [sPossibleAnswers count];
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"UITableViewCellStyleDefault";
  //UITableViewCell 
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
      //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      cell = [[[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.textLabel.font = self.defaultTableCellFont;
  }
    
    
  NSDictionary *answer = [sPossibleAnswers objectAtIndex:indexPath.row];
  cell.textLabel.text = [answer objectForKey:@"title"];
    
    // Implement Accessibility
    [cell setIsAccessibilityElement:YES];
    //[cell setAccessibilityTraits:UIAccessibilityTraitButton];
    //[cell setAccessibilityLabel:@" "];
    //[cell setAccessibilityHint:[cell.textLabel.text stringByAppendingString:NSLocalizedString(@",Answer Option Button", "nil")]]; 
    
    // Fix for 3GS problem - Accessibility puts the focus on a random element (and doesn't change if first responder changes)
    // Build the cell based on whether we are entering this question for the first time or the user has selected a cell
    NSString *newQlabel;
    if (currentHint_ != nil) {
        // First time on this question...read the question and answer
        newQlabel = [NSString stringWithFormat:@"%@", currentHint_];
    }
    else {
        // Been here before...just read what is on this cell
        newQlabel = [NSString stringWithFormat:@"%%@, %@", 
                               cell.textLabel.text, NSLocalizedString(@",Answer Option Button", "nil")];
    }
    
    [cell setAccessibilityLabel:newQlabel]; 
    
    
    
  if ([self.currentQuestion.answer integerValue] == [[answer objectForKey:@"value"] integerValue]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.textColor = self.session.color;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = self.defaultTextColor;
  }
  
  return cell;
}



#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // User is selecting a row...get rid of the 3GS fix for when this table is first displayed
    if (currentHint_ != nil)
    {
        [currentHint_ release];
        currentHint_ = nil;
    }

  // Uncheck the previously checked row.
  if (self.lastSelectedIndexPath.row != indexPath.row) {    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastSelectedIndexPath]; 
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    oldCell.textLabel.textColor = self.defaultTextColor;
  }
  
  // Add a checkmark to the newly selected row.
  UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
  newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    newCell.textLabel.textColor = self.session.color;  
    
    // Change the accessibility info for this question        
    NSString *newQlabel = [NSString stringWithFormat:@"%@, %@", 
                           newCell.textLabel.text, NSLocalizedString(@",Answer Option Button", "nil")];
    [newCell setAccessibilityLabel:newQlabel];

  // Immediately deselect the newly selected row with animation.
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  self.lastSelectedIndexPath = indexPath;  
  
  // Update the answer value for the current question.
  NSDictionary *answer = [sPossibleAnswers objectAtIndex:indexPath.row];
  self.currentQuestion.answer = [answer objectForKey:@"value"];
    
    // Change the Accessibility info so that we read the newly selected answer
    if (answerLabels_ != nil)
    {
        [answerLabels_ release];
        answerLabels_  = nil;
    }
    
    // Now look for an answer
    if ([self.currentQuestion.answer integerValue] > 0)
    {
        // Grab the text for this answer
        NSDictionary *answer = [sPossibleAnswers objectAtIndex:[self.currentQuestion.answer integerValue]-1];
        answerLabels_ = [[NSString alloc] initWithFormat:@"Current answer is %@",[answer objectForKey:@"title"]];
    }
    else
    {
        // There is no answer...should never get here...we just answered it
        answerLabels_ = [[NSString alloc] initWithFormat:@"Not answered yet"];
    }
    
    // Now update all the elements that might use this
    NSString *newHint = [NSString stringWithFormat:@"%@ %@", questionLabels_, answerLabels_];
    [self.navigationItem.leftBarButtonItem setAccessibilityHint:NSLocalizedString(newHint, "")];
    [self.nextButton setAccessibilityHint:NSLocalizedString(newHint, "")];
    [self.previousButton setAccessibilityHint:NSLocalizedString(newHint, "")];
    
    
    // Let's track what the user really clicked on
    NSString *rowTitle = newCell.textLabel.text;
    [Analytics logEvent:[NSString stringWithFormat:@"TABLE: %@, SELECTION: %@",self.title, rowTitle]];   
}

#pragma mark - Instance Methods

/**
 *  headerViewForQuestion
 */
- (UIView *)headerViewForQuestion:(Question *)question {
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
  headerView.backgroundColor = [UIColor whiteColor];
    
  // Gray container view with border around it.
  UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalMargin, headerView.frame.size.width - kUIViewHorizontalMargin - kUIViewVerticalMargin, 0.0)];
  containerView.backgroundColor = self.defaultSolidViewBackgroundColor;
  containerView.layer.borderColor = self.defaultBorderColor.CGColor;
  containerView.layer.borderWidth = 1.0;  
    
  // UILabel that shows "Question 1 of 10", for example
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalMargin, 0.0, 0.0)];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.font = self.defaultTableCellFont;
  titleLabel.textColor = self.defaultTextColor;
  titleLabel.text = [NSString stringWithFormat:@"%@ %i %@ %i", NSLocalizedString(@"Question", @""), [question.rank integerValue], NSLocalizedString(@"of", @""), [self.questions count]];
  
  [titleLabel resizeHeightAndWrapTextToFitWithinWidth:containerView.frame.size.width - (kUIViewHorizontalMargin * 2)];
  [containerView addSubview:titleLabel];

  // UILabel that shows question's text.
  UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  textLabel.backgroundColor = [UIColor clearColor];
  textLabel.font = self.defaultTextFont;
  textLabel.textColor = self.defaultTextColor;
  textLabel.text = question.text;

  [textLabel resizeHeightAndWrapTextToFitWithinWidth:containerView.frame.size.width - (kUIViewHorizontalMargin * 2)];
  [textLabel alignLeftWithView:titleLabel];
  [textLabel positionBelowView:titleLabel margin:kUIViewVerticalMargin];
  [containerView addSubview:textLabel];
      
    
    // Set the Accessibility for the Question Title/Text (and provide the Answer also...if available)
    
    // Change the Label for the Question Title and Text so that they read both no matter which one is clicked
    // Since we are reading both the Title and the Text, we took out the default above (or the system would read that twice!) 
    questionLabels_ = [[NSString alloc] initWithFormat:@"%@, %@", titleLabel.text, textLabel.text];
    [titleLabel setAccessibilityLabel:questionLabels_];
    [textLabel setAccessibilityLabel:questionLabels_];
    
    // Now look for an answer
    if ([question.answer integerValue] > 0)
    {
        // Grab the text for this answer
        NSDictionary *answer = [sPossibleAnswers objectAtIndex:[question.answer integerValue]-1];
        answerLabels_ = [[NSString alloc] initWithFormat:@"Current answer is %@",[answer objectForKey:@"title"]];
    }
    else
    {
        // There is no answer
        answerLabels_ = [[NSString alloc] initWithFormat:@"Not answered yet"];
    }
    
    // Set the Accesssibility info for the Switch Session button (because it gets control first)
    // If it is the first question for this session, we will have VoiceOver read the instructions
    // In all cases, we will concatenate the Question/Answer so that it gets read when the user comes here
    NSString *myInstructions = nil;
    if (bFirstQuestion)
    {
        myInstructions = [NSString stringWithFormat:@"%@, %@, %@", self.instructionsTitle, 
                                                        self.instructionsText, self.instructionsDismiss];
    }
    else
    {        
        myInstructions = @" ";
    }
    
    // Now set the hint on the items that might be the first responder
    NSString *newHint = [NSString stringWithFormat:@"%@ %@, %@, %@", myInstructions, titleLabel.text, textLabel.text, answerLabels_];
    [self.navigationItem.leftBarButtonItem setAccessibilityHint:NSLocalizedString(newHint, "")];
    [self.nextButton setAccessibilityHint:NSLocalizedString(newHint, "")];
    [self.previousButton setAccessibilityHint:NSLocalizedString(newHint, "")];
    
    currentHint_ = [[NSString alloc] initWithFormat:@"%@", newHint];      // Save this for the problem buttons on 3GS devices
    
    // Announce this to the VoiceOver users - This was just a test...this gets overrun by other Voice Over items
    // But it does 'work' in that it will make the Voice Over announcement
    //NSString *strTest = @"Can you hear me now is the time for all good men to come to the aid of their country";
    //UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, strTest);
    
  [textLabel release];
  [titleLabel release];

  // Resize container view to fit both labels.
  [containerView resizeHeightToContainSubviewsWithMargin:kUIViewVerticalMargin];
  [headerView addSubview:containerView];
  
  [containerView release];

  // Resize header view to fit container view.
  [headerView resizeHeightToContainSubviewsWithMargin:0.0];
    
    // Fix for 3GS or iOS 5.0 problem...listen for when we are done with the initial Voice Over
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(receiveAccessibilityNotification:) name:UIAccessibilityVoiceOverStatusChanged object: nil];
    

  return [headerView autorelease];
}

/**
 * pressNextQuestion
 * pressPreviousQuestion
 *
 * We need a bit of misdirection to handle when the user actually clicks the buttons to move to a new questions
 * (as opposed when it happens because of the program flow).  There is a problem on 3GS where the Voice Over is
 * misbehaving for the cells.
 */
- (void)pressNextQuestion{    
    if (currentHint_ != nil)
    {
        [currentHint_ release];
        currentHint_ = nil;
    }
    [self loadNextQuestion];
}
- (void)pressPreviousQuestion{
    if (currentHint_ != nil)
    {
        [currentHint_ release];
        currentHint_ = nil;
    }
    [self loadPreviousQuestion];
}


/**
 *  loadNextQuestion
 */
- (void)loadNextQuestion {
    
    // If this is our first time here (for this session), then display the instructions
    bFirstQuestion = false;
    if (self.currentQuestion == nil) {
        bFirstQuestion = true;
        [MKInfoPanel showPanelInView:self.view 
                                type:MKInfoPanelTypeInfo 
                               title:self.instructionsTitle  
                            subtitle:[self.instructionsText stringByAppendingString:NSLocalizedString(@"\n\nTap to dismiss instructions", "")]
                           hideAfter:300]; 
    }

    if (self.bOnlyUnansweredQuestions) {
        // Are we only dealing with unanswered questions? ...then keep doing that
        [self findFirstUnansweredQuestion];
    } 
    else {  
        // See if we are done yet
        NSUInteger index = [self.questions indexOfObject:self.currentQuestion];
        if (index == [self.questions count] - 1) {
            // If we're showing the last question already, 
            // then show the completed questionnaire view if all the questions have been answered.
            BOOL isAllAnswered = [(QuestionnaireAction *)self.action isFinished];
              
            if (isAllAnswered) {
                ((QuestionnaireAction *)self.action).completionDate = [NSDate date];
                // Ironically, we can get away with just pushing the completed questionnaire controller on to the navigation stack because
                // when that happens, the only navigation button left for the user is the "Done" button, which will take them back to
                // the proper menu. Probably the only place in the entire app that this bizarre navigation is actually useful. Go figure.
                CompletedQuestionnaireViewController *viewController = [[CompletedQuestionnaireViewController alloc] initWithSession:self.session action:self.action];
                [self.navigationController pushViewController:viewController animated:NO];
                [viewController release];
            } else {
                // There are unanswered questions...ask the user if they want to only answer those
                NSString *alertTitle = NSLocalizedString(@"Alert", @"");
                NSString *alertMessage = NSLocalizedString(@"You must answer all the questions in the assessment before viewing your score.\n\nPress OK to go to each unanswered question", @"");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                [alertView show];
                [alertView release];
              }
        } 

        index = index == NSNotFound ? 0 : MIN(index + 1, [self.questions count] - 1);
        [self loadQuestionAtIndex:index];
    }
}


/**
 *  loadPreviousQuestion
 */
- (void)loadPreviousQuestion {
  NSUInteger index = [self.questions indexOfObject:self.currentQuestion];
  index = index == NSNotFound ? 0 : MAX(index - 1, 0);
  [self loadQuestionAtIndex:index];
}

/**
 *  loadQuestionAtIndex
 */
- (void)loadQuestionAtIndex:(NSUInteger)index {
  self.currentQuestion = [self.questions objectAtIndex:index];
  self.lastSelectedIndexPath = nil;
  self.pageControl.currentPage = index;

  // Hide the previous button if we're showing the first question or there are less then two questions total.
  self.previousButton.hidden = (index == 0 || [self.questions count] < 2);
  
  // Hide the next button if there are less then two questions total. We show the next button on the last
  // question because that takes the user to the completed questionnaire view. 
  self.nextButton.hidden = [self.questions count] < 2;

  // Yes, I agree, this seems like a terrible way to do this.... /sigh
  [sPossibleAnswers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSDictionary *answer = (NSDictionary *)obj;
    if (self.currentQuestion.answer == [answer objectForKey:@"value"]) {
      self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
      *stop = YES;
    }
  }];
    
  self.tableView.tableHeaderView = [self headerViewForQuestion:self.currentQuestion];
  [self.tableView reloadData];
    
    // Pause a second or two, then reset the elements for the work around for Voice Over on 3GS (or is it iOS 5) 
    // We have put a fix that only needs to be displayed when the question first comes up.
    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerReset) userInfo:nil repeats:NO];
 
}

// Reset the elements that were modified for the bug in Voice Over  on 3GS iOS5
- (void)timerReset{
    // Set the hint on the items that might be the first responder
    NSString *newHint = [NSString stringWithFormat:@"%@ %@", questionLabels_, answerLabels_];
    [self.navigationItem.leftBarButtonItem setAccessibilityHint:NSLocalizedString(newHint, "")];
    [self.nextButton setAccessibilityHint:NSLocalizedString(newHint, "")];
    [self.previousButton setAccessibilityHint:NSLocalizedString(newHint, "")];
    
    // Reset each row (answer)
    [sPossibleAnswers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];    // Change the accessibility info for this question        
        NSString *newQlabel = [NSString stringWithFormat:@"%@, %@", 
                               nextCell.textLabel.text, NSLocalizedString(@",Answer Option Button", "nil")];
        [nextCell setAccessibilityLabel:newQlabel];
    
    }];
    
}


#pragma mark - UIAlertViewDelegate Methods
// Handle the Alert view when the user has not finished all the questions
// Send them to the first unanswered question if they chose OK
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Button #1 means they want to continue (OK)...see the Alert code above
    if (buttonIndex == 1) {
        // Get the index of the first unanswered question
        [self findFirstUnansweredQuestion];
    }
}


- (void)findFirstUnansweredQuestion {
    // Get the index of the first unanswered question
    NSUInteger nIndex = 0;
    Question *question= [self.questions objectAtIndex:nIndex];
    self.bOnlyUnansweredQuestions = NO;               // Assume we don't have any unanswered questions
    
    // Should be a more elegant way to go through this...
    // but they never seemed to be in index order...
    // So I am using the technique used in in the 'loadquestion...' routines above
    while (question != nil) {
        // If they didn't answer this question, then get out
        if ( [question.answer integerValue] <=0 ) {
            // But this will put us in the mode to only show unanswered questions
            self.bOnlyUnansweredQuestions = YES;    
            
            // Put up a quick message to let them know that we are in 'unanswered question' mode
            
            [MKInfoPanel showPanelInView:self.view 
                                    type:MKInfoPanelTypeInfo 
                                   title:NSLocalizedString(@"Unanswered Question Mode",nil)
                                subtitle:nil //@"Only the questions that have not been answered are being displayed at this time." 
                               hideAfter:1];
            break;
        }
        
        // Get ready to look at the next question
        nIndex++;
        question = nil;
        if (nIndex < [self.questions count])    
            question = [self.questions objectAtIndex:nIndex];
    }
    
    // If we are not done, then go to the first unanswered question
    if (nIndex < [self.questions count])  {
        [self loadQuestionAtIndex:nIndex];
    } else {
        // If we are done...get back in the normal flow 
        // But set ourselves to the last question...
        // Which should detect we are done and move onward...
        nIndex = [self.questions count] - 1;
        self.currentQuestion = [self.questions objectAtIndex:nIndex];
        [self loadNextQuestion];
    }
    
}

@end