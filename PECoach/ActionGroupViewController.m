//
//  ActionGroupViewController.m
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
#import "Analytics.h"

#import "ActionGroupViewController.h"
#import "Action.h"
#import "ActionViewController.h"
#import "AssessSituationsActionViewController.h"
#import "AudioPlayerViewController.h"
#import "CompareSituationsActionViewController.h"
#import "CompleteProgramActionViewController.h"
#import "CompletedQuestionnaireViewController.h"
#import "SituationsActionViewController.h"
#import "HomeworkReviewViewController.h"
#import "ImaginalExposureActionViewController.h"
#import "Librarian.h"
#import "ManageRecordingsActionViewController.h"
#import "PECoachConstants.h"
#import "PECoachAppDelegate.h"
#import "PracticeBreathingActionViewController.h"
#import "QuestionnaireAction.h"
#import "QuestionnaireViewController.h"
#import "QuestionnairesReviewActionViewController.h"
#import "RecordActionViewController.h"
#import "ResetUserDataActionViewController.h"
#import "ScorecardsActionViewController.h"
#import "SecuritySettingsActionViewController.h"
#import "SUDSAnchorViewController.h"
#import "Session.h"
#import "TextVideoActionViewController.h"
#import "TherapistContactActionViewController.h"
#import "WebViewController.h"
#import "Visit.h"
@implementation ActionGroupViewController

#pragma mark - Properties

@synthesize actionGroup = actionGroup_;
@synthesize actionSet = actionSet_;
@synthesize showingChildrenActions = showingChildrenActions_;

#pragma mark - Lifecycle

/**
 *  initWithSession:actionGroup
 */
- (id)initWithSession:(Session *)session actionGroup:(NSString *)group {
  self = [super initWithSession:session action:nil tableStyle:UITableViewStyleGrouped];
  if (self != nil) {
    actionGroup_ = [group copy];
    actionSet_ = [[self.session actionsForGroup:actionGroup_ ] retain];
    showingChildrenActions_ = NO;
    
    self.showDoneButton = NO;
  }
  
  return self;
}

/**
 *  initWithSession:action
 */

- (id)initWithSession:(Session *)session action:(Action *)action {
  self = [super initWithSession:session action:action tableStyle:UITableViewStylePlain];
  if (self != nil) {
    // Sort the child actions by rank
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
    actionSet_ =  [[self.action.children sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] retain];
    showingChildrenActions_ = YES;
    
    [sortDescriptor release];
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (self.action != nil) {
    self.infoLabel.text = self.action.title; 
  } else {
    if ([self.actionGroup isEqualToString:kActionGroupTasks] == YES) {
      self.infoLabel.text = NSLocalizedString(@"Tasks", @"");
    } else if ([self.actionGroup isEqualToString:kActionGroupToolbox] == YES) {
      self.infoLabel.text = NSLocalizedString(@"Toolbox", @"");
    } else if ([self.actionGroup isEqualToString:kActionGroupHomework] == YES) {
      self.infoLabel.text = NSLocalizedString(@"Homework", @"");
    }
  }
}

- (void)viewWillAppear:(BOOL)animated {
    // Only do this if we are in homeword mode
    if ([self.infoLabel.text isEqualToString:@"Homework"]) {
        
        // Find out if we are doing homework  
        PECoachAppDelegate *appDelegate = (PECoachAppDelegate *)[[UIApplication sharedApplication] delegate];
        BOOL doingHomework = [appDelegate doingHomework];
                
        // If we are doing homework and we are coming back here, then we just finished an assignment
        // Save the amount of time spent on it
        if (doingHomework) {
            NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:appDelegate.startVisitDate, @"startDate", [NSDate date], @"endDate", nil];
            Visit *visit = [self.librarian insertNewVisitWithValues:values];
            visit.action = appDelegate.actionHomework;              //   self.action;
            
            self.action.completed = [NSNumber numberWithBool:YES];
            [self.librarian save];
            
            // Not doing homework again until the user selects an assignment
            appDelegate.doingHomework = NO;
        }  
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"ACTION GROUP VIEW"];

    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [actionGroup_ release];
  [actionSet_ release];
  
  [super dealloc];
}

#pragma mark - Instance Methods

/**
 *  handleActionSelected 
 */
- (void)handleActionSelected:(Action *)action {
  ActionViewController *actionViewController = nil;
  WebViewController *webViewController = nil;  
  BOOL animate = YES;
  
  if ([action.type isEqualToString:kActionTypeAppendSituations] == YES) {
      actionViewController = [[SituationsActionViewController alloc] initWithSession:self.session action:action situationMode:kSituationActionViewModeAppendSituations];
  } else if ([action.type isEqualToString:kActionTypeSUDSAnchors] == YES) {
      actionViewController = [[SUDSAnchorViewController alloc] initWithSession:self.session action:action];
      //[self presentModalViewController:sudsController animated:YES];
  } else if ([action.type isEqualToString:kActionTypeAppointments] == YES) {
    [Analytics logEvent:@"APPOINTMENTS AND REMINDERS"];
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEventEditViewController *eventViewController = [[EKEventEditViewController alloc] init];
    eventViewController.eventStore = eventStore;
    eventViewController.editViewDelegate = self;
    
    [self presentModalViewController:eventViewController animated:YES];
    
    [eventViewController release];
    [eventStore release];
  } else if ([action.type isEqualToString:kActionTypeAssessSituations] == YES) {
    // Grab the second session.
    NSArray *sessions = [self.librarian allSessions];
    Session *session = [sessions count] > 0 ? [sessions objectAtIndex:1] : nil;
    actionViewController = [[AssessSituationsActionViewController alloc] initWithSession:self.session action:action situations:session.nativeSituations];
  } else if ([action.type isEqualToString:kActionTypeAudioSessionPlayback] == YES) {
      BOOL bSkipPlayback = NO;
      // Are we recording right now?  If so, we can't listen to the recording...
      if (self.session.audioRecorder != Nil) {
          if (self.session.audioRecorder.isRecording == YES) {
              
              // Let the user know this action will stop the recording
              UIAlertView *alert = [[UIAlertView alloc]
                                    initWithTitle:NSLocalizedString(@"Recording in Progress",nil)
                                    message:NSLocalizedString(@"The recording cannot be listened to while the recording is in progress.",nil)
                                    delegate:nil
                                    cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                    otherButtonTitles:nil, nil];
              [alert show];
              [alert release];
              
              bSkipPlayback = YES;              
          }
      }
      
      // Only play the audio if we are not still recording it!
      if (!bSkipPlayback)
          // 06/19/2012  Revert back to orginal
          //actionViewController = [[ImaginalExposureActionViewController alloc] initWithSession:self.session action:action playAll:YES];
          actionViewController = [[AudioPlayerViewController alloc] initWithSession:self.session action:action];
      
  } else if ([action.type isEqualToString:kActionTypeAudioImaginalExposurePlayback] == YES) {
      
      BOOL bSkipPlayback = NO;
      // Are we recording right now?  If so, we can't listen to the recording...
      if (self.session.audioRecorder != Nil) {
          if (self.session.audioRecorder.isRecording == YES) {
              
              // Let the user know this action will stop the recording
              UIAlertView *alert = [[UIAlertView alloc]
                                    initWithTitle:NSLocalizedString(@"Recording in Progress",nil)
                                    message:NSLocalizedString(@"The recording cannot be listened to while the recording is in progress.",nil)
                                    delegate:nil
                                    cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                    otherButtonTitles:nil, nil];
              [alert show];
              [alert release];
              
              bSkipPlayback = YES;              
          }
      }
      
      // Only play the imaginal audio if we are not still recording it!
      if (!bSkipPlayback)
          actionViewController = [[ImaginalExposureActionViewController alloc] initWithSession:self.session action:action];
      // 06/19/2012 Revert back to original
      //actionViewController = [[ImaginalExposureActionViewController alloc] initWithSession:self.session action:action playAll:NO];
      
  } else if ([action.type isEqualToString:kActionTypeCompareSituations] == YES) {
    NSArray *sessions = [self.librarian allSessions];
    Session *session = [sessions count] > 0 ? [sessions objectAtIndex:1] : nil;
    actionViewController = [[CompareSituationsActionViewController alloc] initWithSession:self.session action:action situations:session.nativeSituations];
  } else if ([action.type isEqualToString:kActionTypeCompleteProgram] == YES) {
    actionViewController = [[CompleteProgramActionViewController alloc] initWithSession:self.session action:action];
  } else if ([action.type isEqualToString:kActionTypeEditSituations] == YES) {
    actionViewController = [[SituationsActionViewController alloc] initWithSession:self.session action:action situationMode:kSituationActionViewModeEditSituations];
  } else if ([action.type isEqualToString:kActionTypeCreateSituations] == YES) {
    actionViewController = [[SituationsActionViewController alloc] initWithSession:self.session action:action situationMode:kSituationActionViewModeCreateSituations];
  } else if ([action.type isEqualToString:kActionTypeEditSecuritySettings] == YES) {
    actionViewController = [[SecuritySettingsActionViewController alloc] initWithSession:self.session action:action];
  } else if ([action.type isEqualToString:kActionTypeListScorecards] == YES) {
    NSSet *scorecards = [self.session allScorecardsIncludingPreviousSessions:YES];
    actionViewController = [[ScorecardsActionViewController alloc] initWithSession:self.session 
                                                                            action:action 
                                                                        scorecards:scorecards 
                                                                       displayMode:kScorecardsActionViewDisplayModeList];
  } else if ([action.type isEqualToString:kActionTypeListSituations] == YES) {
    actionViewController = [[SituationsActionViewController alloc] initWithSession:self.session action:action situationMode:kSituationActionViewModeListSituations];
  } else if ([action.type isEqualToString:kActionTypeManageAudioRecordings] == YES) {
    actionViewController = [[ManageRecordingsActionViewController alloc] initWithSession:self.session action:action];
  } else if ([action.type isEqualToString:kActionTypeParent] == YES) {
    actionViewController = [[ActionGroupViewController alloc] initWithSession:self.session action:action];
  } else if ([action.type isEqualToString:kActionTypePracticeBreathing] == YES) {
    actionViewController = [[PracticeBreathingActionViewController alloc] initWithSession:self.session action:action];
  } else if ([action.type isEqualToString:kActionTypeQuestionnaire] == YES) {
    BOOL questionnaireFinished = [(QuestionnaireAction *)action isFinished];
    if (questionnaireFinished == YES) {
      if ([self.session isFinalSession] == YES) {
        actionViewController = [[QuestionnairesReviewActionViewController alloc] initWithSession:self.session action:action];
      } else {
        actionViewController = [[CompletedQuestionnaireViewController alloc] initWithSession:self.session action:action];
      }
    } else {
      actionViewController = [[QuestionnaireViewController alloc] initWithSession:self.session action:action];
    }
  } else if ([action.type isEqualToString:kActionTypeRecordSession] == YES) {
    // This is a rather ugly hack but what we really need to be doing here is switch
    // to the "Record" tab. Why this option is in the menu as well is beyond me.
    UIViewController *recordViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    if ([recordViewController isKindOfClass:[ActionViewController class]] == YES) {
      [(ActionViewController *)recordViewController setAction:action];
    }
    self.tabBarController.selectedIndex = 1;
  } else if ([action.type isEqualToString:kActionTypeResetUserData] == YES) {
    actionViewController = [[ResetUserDataActionViewController alloc] initWithSession:self.session action:action];
  } else if ([action.type isEqualToString:kActionTypeReviewHomework] == YES) {
    actionViewController = [[HomeworkReviewViewController alloc] initWithSession:self.session action:action];
  } else if ([action.type isEqualToString:kActionTypeSelectSituations] == YES) {
    actionViewController = [[SituationsActionViewController alloc] initWithSession:self.session action:action situationMode:kSituationActionViewModeSelectSituations];
  } else if ([action.type isEqualToString:kActionTypeTextVideo] == YES) {
    actionViewController = [[TextVideoActionViewController alloc] initWithSession:self.session action:action];
  } else if ([action.type isEqualToString:kActionTypeTherapistContactInformation] == YES) {
    actionViewController = [[TherapistContactActionViewController alloc] initWithSession:self.session action:action];
  } else if ([action.type isEqualToString:kActionTypeWebView] == YES) {
    webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
  }
  
  if (actionViewController != nil) {
    // Hack to support UI requirement of using a non iOS friendly navigation flow.
    if (self.showingChildrenActions) {
      actionViewController.showDoneButton = NO;
      actionViewController.showHomeButton = NO;
    }
      
      // If we are in homework mode, start the timer
      if ([self.infoLabel.text isEqualToString:@"Homework"]) {
          PECoachAppDelegate *appDelegate = (PECoachAppDelegate *)[[UIApplication sharedApplication] delegate];
          appDelegate.doingHomework = YES;
          appDelegate.startVisitDate = [NSDate date];
          
          // And grab the action that we are doing
          appDelegate.actionHomework = action;
      }
    
    [self.navigationController pushViewController:actionViewController animated:animate];
    [actionViewController release];
  } else if (webViewController != nil) {
      webViewController.title = NSLocalizedString(@"Clinician's Guide", @"");
      
      // Before we go...mark this action as completed...getting missed elsewhere
      action.completed = [NSNumber numberWithBool:YES];
      [self.navigationController pushViewController:webViewController animated:YES];
      [webViewController release];
  } else {
    // Means that the feature has yet to be implemented....
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
  }
}

#pragma mark - EKEventEditViewDelegate Methods

/**
 *  eventEditViewController:didCompleteWithAction
 */
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
  if (action == EKEventEditViewActionSaved) {
    [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:nil];
      
      
      // Let the user know this action will stop the recording
      UIAlertView *alert = [[UIAlertView alloc]
                            initWithTitle:NSLocalizedString(@"Appointment Saved",nil)
                            message:NSLocalizedString(@"The Event has been added to your Calendar.",nil)
                            delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                            otherButtonTitles:nil, nil];
      [alert show];
      [alert release];
  }
      
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource Methods

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.actionSet count];
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = self.defaultTextColor;
    cell.textLabel.font = self.defaultTableCellFont;
  }

  // Configure the cell...
  Action *action = [self.actionSet objectAtIndex:indexPath.row];
  cell.textLabel.text = action.title;
    
    // Implement Accessibility
    [cell setIsAccessibilityElement:YES];
    [cell setAccessibilityLabel:cell.textLabel.text];
    [cell setAccessibilityTraits:UIAccessibilityTraitButton];
    
  if ([action.completed boolValue] == YES) {
    // Use a blank PNG instead of setting image to nil to preserve cell indentation.
    cell.imageView.image = [UIImage imageNamed:@"blankTableCellBullet.png"];
  } else {
    cell.imageView.image = [UIImage imageNamed:self.session.icon];
  }
  
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Action *action = [self.actionSet objectAtIndex:indexPath.row];
  [self handleActionSelected:action];
    
    // If we are in Homework mode...
    if ([self.infoLabel.text isEqualToString:@"Homework"]) {
        // If we are doing homework, save this as the Action that we will report on
        PECoachAppDelegate *appDelegate = (PECoachAppDelegate *)[[UIApplication sharedApplication] delegate];
        BOOL doingHomework = [appDelegate doingHomework];
        if (doingHomework) {
            appDelegate.actionHomework = action;
        }
        
    }
  
  // Bit of an ugly hack here to forcibly mark these two "special" actions as completed:
  if ([action.type isEqualToString:kActionTypeAppointments] == YES || [action.type isEqualToString:kActionTypeRecordSession] == YES) {
    action.completed = [NSNumber numberWithBool:YES];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
  }
}

@end
