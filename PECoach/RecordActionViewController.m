//
//  RecordActionViewController.m
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
#import <AVFoundation/AVFoundation.h>
#import "RecordActionViewController.h"
#import "Action.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "Recording.h"
#import "Session.h"
#import "UIView+Positionable.h"
#import "Analytics.h"
#import "MKInfoPanel.h"
#import "AuxSessionInfo.h"

// Alert View Tags
#define ALERTVIEW_END_EXPOSURE      100
#define ALERTVIEW_RECORDING_ERROR   101
#define ALERTVIEW_STOP_RECORDING    102
#define ALERTVIEW_OVERWRITE_RECORDING 103
#define ALERTVIEW_OVERWRITE_IMAGINAL 104

@implementation RecordActionViewController

#pragma mark - Properties

@synthesize elapsedTimeLabel = elapsedTimeLabel_;
@synthesize recordingButton = recordingButton_;
//@synthesize pauseButton = pauseButton_;

@synthesize beginExposureButton = beginExposureButton_;
@synthesize beginExposureTimestampLabel = beginExposureTimestampLabel_;
@synthesize endExposureButton = endExposureButton_;
@synthesize endExposureTimestampLabel = endExposureTimestampLabel_;

@synthesize hideImaginalExposureButtons = hideImaginalExposureButtons_;
@synthesize timer = timer_;

@synthesize bAddRecordingMode = bAddRecordingMode_;

@synthesize instructionsTitle = instructionsTitle_;
@synthesize instructionsText = instructionsText_;
@synthesize instructionsDismiss = instructionsDismiss_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action
 */
- (id)initWithSession:(Session *)session action:(Action *)action {
  self = [super initWithSession:session action:action];
    /*
    NSArray *testSessions = [self.librarian allSessions];
     // Let's look at the array of sessions
     NSEnumerator *e = [testSessions objectEnumerator];
     id object;
     int cnt=0;
     while (object = [e nextObject]) {
     Session *mySession = (Session *)object;
     NSLog(@"cnt: %d  title:%@ rank:%@",cnt++,mySession.title,mySession.rank);
     }
     */
     
  if (self != nil) {
      Session *secondSession = [[self.librarian allSessions] objectAtIndex:1];
      //NSLog(@"This Session  title:%@ rank:%@",session.title,session.rank);
      //NSLog(@"Second Session  title:%@ rank:%@",secondSession.title,secondSession.rank);
    hideImaginalExposureButtons_ = ([session.rank integerValue] <= [secondSession.rank integerValue]);
  }
    
    // Specify localized text that is used in mulitple locations (avoid duplication)
    instructionsTitle = NSLocalizedString(@"Recording In Progress!",nil);
    instructionsText = NSLocalizedString(@"If this PE Coach App is not visible on your device, the recording will pause or stop!  However, you can move to other screens within PE Coach without affecting your recording.\x0A\x0A",nil);
    instructionsDismiss = NSLocalizedString(@"If you do leave PE Coach, your recording will restart when you return.",nil);
    

  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
    
    // We aren't adding new recordings now
    self.bAddRecordingMode = FALSE;
  
  self.infoLabel.text = NSLocalizedString(@"Record Session", nil);

  // Start/Stop recording button.
  UIButton *controlButton = [self buttonWithTitle:NSLocalizedString(@"Start Recording", nil)];
  [controlButton addTarget:self action:@selector(handleRecordingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  
  CGRect buttonFrame = controlButton.frame;
  buttonFrame.size.width = 200.0;
  controlButton.frame = buttonFrame;
  
  [self.view addSubview:controlButton];
  self.recordingButton = controlButton;
  
  self.recordingButton.frame = CGRectOffset(self.recordingButton.frame, 0.0, [self contentFrame].origin.y + kUIViewVerticalInset);
  [self.recordingButton centerHorizontallyInView:self.view];
  
  // Elapsed time label
  UILabel *elapsedTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  elapsedTimeLabel.backgroundColor = [UIColor clearColor];
  elapsedTimeLabel.font = [UIFont systemFontOfSize:24.0];
  elapsedTimeLabel.text = @"00:00:00";
    elapsedTimeLabel.textColor = [UIColor whiteColor];
  [elapsedTimeLabel sizeToFit];
    
    // VoiceOver hint (so the user knows what the numbers mean)
    [elapsedTimeLabel setAccessibilityHint:NSLocalizedString(@"Length of Recording in hours minutes seconds", "nil")];

  [self.view addSubview:elapsedTimeLabel];
  self.elapsedTimeLabel = elapsedTimeLabel;
  [elapsedTimeLabel release];
  
  if (self.hideImaginalExposureButtons == YES) {
    self.elapsedTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.recordingButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.recordingButton centerVerticallyInView:self.view];
  }
  
  [self.elapsedTimeLabel positionBelowView:self.recordingButton margin:kUIViewVerticalMargin];
  [self.elapsedTimeLabel centerHorizontallyInView:self.view];
  
    /* 1-10-2012 Don't implement the Pause button.  iOS doesn't handle start/stop of recording sessions very well
     
    // Pause recording button.
    UIButton *pauseButton = [self buttonWithTitle:NSLocalizedString(@"Pause Recording", nil)];
    [pauseButton addTarget:self action:@selector(handlePauseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect pauseFrame = pauseButton.frame;
    pauseFrame.size.width = 200.0;
    pauseButton.frame = pauseFrame;
    
    [self.view addSubview:pauseButton];
    self.pauseButton = pauseButton;
    
    //self.pauseButton.frame = CGRectOffset(self.pauseButton.frame, 0.0, [self contentFrame].origin.y + kUIViewVerticalInset);
    [self.pauseButton positionBelowView:self.elapsedTimeLabel margin:kUIViewVerticalMargin];
    [self.pauseButton centerHorizontallyInView:self.view];
    self.pauseButton.hidden = YES;              // Don't show it until we are recording
     */
    
  // Begin Imaginal Exposure Button and Timestamp
  UIButton *beginExposureButton = [self buttonWithTitle:NSLocalizedString(@"Begin Exposure", nil)];
  [beginExposureButton addTarget:self action:@selector(handleBeginExposureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  
  CGRect imaginalFrame = beginExposureButton.frame;
  imaginalFrame.origin.x = kUIViewHorizontalInset;
  imaginalFrame.size.width = 180.0;
  
  beginExposureButton.frame = imaginalFrame;
  [beginExposureButton positionBelowView:self.elapsedTimeLabel margin:kUIViewVerticalMargin * 10];
  
  [self.view addSubview:beginExposureButton];
  self.beginExposureButton = beginExposureButton;
  
  UILabel *beginExposureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  beginExposureLabel.backgroundColor = [UIColor clearColor];
  beginExposureLabel.textColor = [UIColor whiteColor];
  beginExposureLabel.font = [UIFont systemFontOfSize:17.0];
  beginExposureLabel.text = @"00:00";
  beginExposureLabel.textAlignment = UITextAlignmentCenter;
  [beginExposureLabel sizeToFit];
  
  imaginalFrame = beginExposureLabel.frame;
  imaginalFrame.size.height = self.beginExposureButton.frame.size.height;
  imaginalFrame.size.width = 90.0;
  
  beginExposureLabel.frame = imaginalFrame;
  [beginExposureLabel positionToTheRightOfView:self.beginExposureButton margin:kUIViewHorizontalMargin];
  [beginExposureLabel alignTopWithView:self.beginExposureButton];
  
  [self.view addSubview:beginExposureLabel];
  self.beginExposureTimestampLabel = beginExposureLabel;
  [beginExposureLabel release];
  
  // End Imaginal Exposure Button and Timestamp
  UIButton *endExposureButton = [self buttonWithTitle:NSLocalizedString(@"End Exposure", nil)];
  [endExposureButton addTarget:self action:@selector(handleEndExposureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  
  endExposureButton.frame = self.beginExposureButton.frame;
  [endExposureButton positionBelowView:self.beginExposureButton margin:kUIViewVerticalMargin];
  
  [self.view addSubview:endExposureButton];
  self.endExposureButton = endExposureButton;

  UILabel *endExposureLabel = [[UILabel alloc] initWithFrame:self.beginExposureTimestampLabel.frame];
  endExposureLabel.backgroundColor = self.beginExposureTimestampLabel.backgroundColor;
  endExposureLabel.textColor = [UIColor whiteColor];
  endExposureLabel.font = self.beginExposureTimestampLabel.font;
  endExposureLabel.text = self.beginExposureTimestampLabel.text;
  endExposureLabel.textAlignment = self.beginExposureTimestampLabel.textAlignment;

  [endExposureLabel positionBelowView:self.beginExposureTimestampLabel margin:kUIViewVerticalMargin];
  [self.view addSubview:endExposureLabel];
  self.endExposureTimestampLabel = endExposureLabel;
  [endExposureLabel release];
  
  Recording *existingRecording = self.session.recording;
  if (existingRecording != nil) {
    // If there's already an existing recording, then load the timestamp information for that recording.
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:existingRecording.filePath] error:nil];
    [self setTextForTimestampLabel:self.elapsedTimeLabel withTimeInterval:player.duration];
    [self setTextForTimestampLabel:self.beginExposureTimestampLabel withTimeInterval:[existingRecording.imaginalExposureStartsOffset doubleValue]];
    [self setTextForTimestampLabel:self.endExposureTimestampLabel withTimeInterval:[existingRecording.imaginalExposureEndsOffset doubleValue]];
    [player release];
  }
  
  self.beginExposureButton.hidden = self.hideImaginalExposureButtons;
  self.beginExposureTimestampLabel.hidden = self.hideImaginalExposureButtons;
  self.endExposureButton.hidden = self.hideImaginalExposureButtons;
  self.endExposureTimestampLabel.hidden = self.hideImaginalExposureButtons;
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {  
  self.elapsedTimeLabel = nil;
  self.recordingButton = nil;
  self.beginExposureButton = nil;
  self.beginExposureTimestampLabel = nil;
  self.endExposureButton = nil;
  self.endExposureTimestampLabel = nil;

  [super viewDidUnload];
}

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (self.session.audioRecorder.isRecording == YES) {
    [self setRecordingButtonTitle:NSLocalizedString(@"Stop Recording", nil)];
  } else {
    [self setRecordingButtonTitle:NSLocalizedString(@"Start Recording", nil)];
  }

  self.beginExposureButton.enabled = self.session.audioRecorder.isRecording;
  self.endExposureButton.enabled = self.session.audioRecorder.isRecording;
  
  NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
  self.timer = timer;
}

/**
 *  viewWillDisappear
 */
- (void)viewWillDisappear:(BOOL)animated {
  [self.timer invalidate];
  self.timer = nil;
  
  [super viewWillDisappear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    //[Analytics logEvent:@"RECORD ACTION VIEW"];
    //[Analytics logEvent:[NSString stringWithFormat:@"RECORD ACTION VIEW: %@ ITEM: %@",self.navigationItem.title, self.infoLabel.text]];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [elapsedTimeLabel_ release];
  [recordingButton_ release];
  [beginExposureButton_ release];
  [beginExposureTimestampLabel_ release];
  [endExposureButton_ release];
  [endExposureTimestampLabel_ release];
  
  [super dealloc];
}

#pragma mark - UI Actions

/**
 *  handleRecordingButtonTapped
 */
- (IBAction)handleRecordingButtonTapped:(id)sender {
    if (self.session.audioRecorder.isRecording == YES) { 
        /*NSString *alertTitle = NSLocalizedString(@"STOP the Recording?", @"");
        NSString *alertMessage = NSLocalizedString(@"It is suggested that you record the session without stopping.  If the session is not finished, please remember to restart the recording!\n\nPress STOP to confirm.\n\nPress CONTINUE to resume.", @"");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"CONTINUE RECORDING", @"") otherButtonTitles:NSLocalizedString(@"STOP RECORDING", @""), nil];
         */
        // User tapped the button while it said 'Stop Recording'
        // Let the user know this will STOP the recording and they can't restart it...only overwrite it
        // Make them confirm this is what they want to do
        NSString *alertTitle = NSLocalizedString(@"STOP the Recording?", @"");
        NSString *alertMessage = NSLocalizedString(@"It is suggested that you record the session without stopping.  If the session is not finished, please remember to restart the recording!", @"");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"CONTINUE RECORDING", @"") otherButtonTitles:NSLocalizedString(@"STOP RECORDING", @""), nil];
        
         for (UIView *subView in alertView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                //this is a button...make it two line
                UIButton *button = (UIButton*)subView;
                button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
            }
        }
         
        [alertView setTag:ALERTVIEW_STOP_RECORDING];
        [alertView show];
        [alertView release];
  } else {
    // User tapped the button while it said 'Start Recording'  
    [self startRecording];
  }
}

/**
 *  handlePauseButtonTapped
 */
/* 1-10-2012 Don't implement the Pause button
- (IBAction)handlePauseButtonTapped:(id)sender {
    // If we are recording, then pause it
    if (self.session.audioRecorder.isRecording == YES) { 
        // Pause the recording
        [self.session.audioRecorder pause];
        
        // Indicate to the user that the recording is paused and give them a way to restart it
        self.recordingButton.enabled = NO;      // Don't let them STOP the recording
        [self.pauseButton setTitle:NSLocalizedString(@"Resume Recording", nil) forState:UIControlStateNormal];    
        // Add a badge to the tab bar to indicate that we're paused.
        UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:1];
        tabBarItem.badgeValue = @"P";
    } else {
        // We are paused...resume the recording
        [self.session.audioRecorder record];
        
        self.recordingButton.enabled = YES;     // Give them access to the STOP button again
        [self.pauseButton setTitle:NSLocalizedString(@"Pause Recording", nil) forState:UIControlStateNormal];    
        // Add a badge to the tab bar to indicate that we're recording again.
        UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:1];
        tabBarItem.badgeValue = @"";
    }
}
*/

-(void)startExposure {
    
    [Analytics logEvent:@"BEGIN EXPOSURE TIMER" timed:YES];
    self.session.recording.imaginalExposureStartsOffset = [NSNumber numberWithDouble:self.session.audioRecorder.currentTime];
    
    // Retrieve (and save) the name and attributes of the imaginal recording file
    AuxSessionInfo *auxInfo = [AuxSessionInfo alloc];
    auxInfo.pListFileName = [[NSString alloc] initWithFormat:@"AuxSessionInfo %@",self.session.rank];
    //NSLog(@"AuxSessionInfo plistfilename: %@",auxInfo.pListFileName);
    [auxInfo initPlist];
    auxInfo.imaginalFileNameStart = [[NSString alloc] initWithString:self.session.recording.filePath];
    auxInfo.imaginalFileNameEnd = [[NSString alloc] initWithString:self.session.recording.filePath];
    auxInfo.numberOfImaginalFiles = [[NSNumber alloc] initWithInteger:1];
    auxInfo.imaginalExposureStartsOffset = [[NSNumber alloc] initWithDouble:[self.session.recording.imaginalExposureStartsOffset doubleValue]];
    auxInfo.imaginalExposureEndsOffset = [[NSNumber alloc] initWithDouble:0.0];     
    [auxInfo writeToPlist];
    [auxInfo release];
    
    [self setTextForTimestampLabel:self.beginExposureTimestampLabel withTimeInterval:[self.session.recording.imaginalExposureStartsOffset doubleValue]];
    
    // Don't let them reset this...at least not until they finish it
    self.beginExposureButton.enabled = NO;
}

/**
 *  handleBeginExposureButtonTapped
 */
- (IBAction)handleBeginExposureButtonTapped:(id)sender {
    if (self.session.recording != nil) {
        // Retrieve the name and attributes of the imaginal recording file
        AuxSessionInfo *auxInfo = [AuxSessionInfo alloc];
        auxInfo.pListFileName = [[NSString alloc] initWithFormat:@"AuxSessionInfo %@",self.session.rank];
       // NSLog(@"AuxSessionInfo plistfilename: %@",auxInfo.pListFileName);
        BOOL bImaginalFileExists_ = [auxInfo initPlist];
        
        // Warn the user if the Imaginal recording ready exists  
        if (bImaginalFileExists_ && [auxInfo.imaginalExposureEndsOffset doubleValue] != 0.0) {
            // But it only REALLY exists if the start and end times have been specified!
            // We only check the end times...in practical terms, if there is an imaginal file neither could possibly be 0.0
           /* 
            NSString *alertTitle = NSLocalizedString(@"Replace Existing Imaginal Recording?", @"");
            NSString *alertMessage = NSLocalizedString(@"This action will replace the Existing Imaginal Recording.\n\nPress REPLACE to continue with this action.", @"");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"REPLACE", @"") otherButtonTitles:NSLocalizedString(@"CANCEL", @""), nil];
            */
                // Let the user know this will overwrite the existing Imaginal offsets
                // Make them confirm this is what they want to do
                NSString *alertTitle = NSLocalizedString(@"Replace Existing Imaginal Recording?", @"");
                NSString *alertMessage = NSLocalizedString(@"This action will replace the Existing Imaginal Recording.", @"");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"REPLACE IMAGINAL", @"") otherButtonTitles:NSLocalizedString(@"KEEP IMAGINAL", @""), nil];
            [alertView setTag:ALERTVIEW_OVERWRITE_IMAGINAL];   
            for (UIView *subView in alertView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    //this is a button...make it two line
                    UIButton *button = (UIButton*)subView;
                    button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
                }
            }
                [alertView show];
                [alertView release];
                     

        } else {
            // Imaginal Recording does not exist...let them start one
            [self startExposure];
        }
        
        [auxInfo release];
  }
}

/**
 *  handleEndExposureButtonTapped
 */
- (IBAction)handleEndExposureButtonTapped:(id)sender {
    if (self.session.recording != nil) {
        /*
        NSString *alertTitle = NSLocalizedString(@"Attention!", @"");
        NSString *alertMessage = NSLocalizedString(@"This will END the Imaginal Exposure portion of the recording.\n\nPress END to confirm this action.\n\nPress CONTINUE to resume the Imaginal Exposure portion of the recording.", @"");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"CONTINUE RECORDING", @"") otherButtonTitles:NSLocalizedString(@"END RECORDING", @""), nil];
         */
        // Let the user know this will end the exposure timing...and it can't be done again
        // Make them confirm this is what they want to do
        NSString *alertTitle = NSLocalizedString(@"Attention!", @"");
        NSString *alertMessage = NSLocalizedString(@"This will END the Imaginal Exposure portion of the recording.", @"");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"CONTINUE IMAGINAL", @"") otherButtonTitles:NSLocalizedString(@"END IMAGINAL", @""), nil]; 
        
         for (UIView *subView in alertView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                //this is a button...make it two line
                UIButton *button = (UIButton*)subView;
                button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
            }
        }
         
        [alertView setTag:ALERTVIEW_END_EXPOSURE];
        [alertView show];
        [alertView release];
  }
}

/**
 *  handleDoneButtonTapped
 */
- (void)handleDoneButtonTapped:(id)sender {
  // Grr, we need to hijack this so that we can send the user back to the first tab. 
  self.tabBarController.selectedIndex = 0;
}

#pragma mark - UIAlertViewDelegate Methods
// Handle the Alert view when the user has pressed the End Exposure button
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // END EXPOSURE TIMER
    if ([alertView tag] == ALERTVIEW_END_EXPOSURE)
    {        
        // The user has confirmed that they want to END the Exposure Recording...so do  it
        if (buttonIndex == 1)
        {
            [Analytics endTimedEvent:@"END EXPOSURE TIMER" withParameters:Nil];
            self.session.recording.imaginalExposureEndsOffset = [NSNumber numberWithDouble:self.session.audioRecorder.currentTime];
            [self setTextForTimestampLabel:self.endExposureTimestampLabel withTimeInterval:[self.session.recording.imaginalExposureEndsOffset doubleValue]];  
            
            // And disable the button so they are not tempted to do it again!
            self.endExposureButton.enabled = NO;
            
            // Save the exposure start/end values
            AuxSessionInfo *auxInfo = [AuxSessionInfo alloc];
            auxInfo.pListFileName = [[NSString alloc] initWithFormat:@"AuxSessionInfo %@",self.session.rank];
            //NSLog(@"AuxSessionInfo plistfilename: %@",auxInfo.pListFileName);
            [auxInfo initPlist];
            
            // Only update the end file
            auxInfo.imaginalFileNameEnd = [[NSString alloc] initWithString:self.session.recording.filePath];
            //auxInfo.numberOfImaginalFiles = [[NSNumber alloc] initWithInteger:1];
            //auxInfo.imaginalExposureStartsOffset = [[NSNumber alloc] initWithDouble:[self.session.recording.imaginalExposureStartsOffset doubleValue]];
            
            // Use the current recording time if we are using multiple recordings?
            auxInfo.imaginalExposureEndsOffset = [[NSNumber alloc] initWithDouble:[self.session.recording.imaginalExposureEndsOffset doubleValue]];     
            [auxInfo writeToPlist];
            [auxInfo release];
        }
    }
    
    // RECORDING ERROR
    if ([alertView tag] == ALERTVIEW_RECORDING_ERROR){
        // Not implemented...the Alert does not specify a delegate
        // If we want to respond to this error in the future...this is where you do it
        //NSLog(@"UIAlertViewDelegateMethod: Recording Error");
    }
    
    // STOP RECORDING
    if ([alertView tag] == ALERTVIEW_STOP_RECORDING){
        // The user has confirmed that they want to STOP the Recording...so do  it
        if (buttonIndex == 1)
        {
            [self stopRecording];
        }
    }
    
    // OVERWRITE RECORDING
    if ([alertView tag] == ALERTVIEW_OVERWRITE_RECORDING){
        // The user has confirmed that they want to OVERWRITE the Recording...so do  it
        if (buttonIndex == 0)
        {
            [self removeExistingRecording];
            [self startRecording];
        }
    }
    
    // OVERWRITE IMAGINAL
    if ([alertView tag] == ALERTVIEW_OVERWRITE_IMAGINAL){
        // The user has confirmed that they want to OVERWRITE the Imaginal Recording...so do  it
        if (buttonIndex == 0)
        {
            [self startExposure];
        }
    }
}

#pragma mark - UIActionSheetDelegate Methods

/**
 *  actionSheet:clickedButtonAtIndex
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  // User hit the Start Recording button and there already was a recording
  // ...this will wipe out the original recording and they were asked if they really want to do that  
  // Button indexes start at zero and increase from top to bottom in the action sheet.
    switch (buttonIndex) {
        case 0:
        {
           /*
            NSString *alertTitle = NSLocalizedString(@"OVERWRITE the Recording?", @"");
            NSString *alertMessage = NSLocalizedString(@"You are about to erase the existing recording.  The entire session will be lost and cannot be retrieved.\n\nPress OVERWRITE to erase the existing recording.\n\nPress SKIP to continue.", @"");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"OVERWRITE RECORDING", @"") otherButtonTitles:NSLocalizedString(@"SKIP", @""), nil];
            */
                // They are sure they want to delete the old recording and start a new one
                // But ask them again anyway!
                NSString *alertTitle = NSLocalizedString(@"OVERWRITE the Recording?", @"");
                NSString *alertMessage = NSLocalizedString(@"You are about to erase the existing recording.  The entire session will be lost and cannot be retrieved.", @"");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"OVERWRITE RECORDING", @"") otherButtonTitles:NSLocalizedString(@"KEEP RECORDING", @""), nil];
                [alertView setTag:ALERTVIEW_OVERWRITE_RECORDING];    
                for (UIView *subView in alertView.subviews) {
                    if ([subView isKindOfClass:[UIButton class]]) {
                        //this is a button...make it two line
                        UIButton *button = (UIButton*)subView;
                        button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
                    }
                }
                [alertView show];
                [alertView release];
            }
            break;
            
        case 1:
            // They want to add another recording
            self.bAddRecordingMode = TRUE;          // Let 'startRecording' know this is OK
            [self startRecording];
            break;
            
        default:
            // They canceled...don't do anything
            break;
    }  
}

#pragma mark - Instance Methods

/**
 *  removeExistingRecording
 */
- (void)removeExistingRecording {
  Recording *recording = self.session.recording;
  if (recording != nil) {
      // Delete the file that is saved in librarian
      [self.librarian deleteObject:recording];
      self.session.recording = nil; 
      
      // Look for any additional recordings for this session
      NSFileManager *fileManager = [[NSFileManager alloc] init];
      NSString *applicationDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
      
      // We are just looking for audio files that belong to this session
      NSString *filePrefix = [NSString stringWithFormat:@"%@ Recording", self.session.title];
      NSError *error = nil;
      for (NSString *filename in [fileManager contentsOfDirectoryAtPath:applicationDocumentsPath error:&error]) {
          // Only delete files with our filePrefix
          NSRange prefixRange = [filename rangeOfString:filePrefix];
          if (prefixRange.location != NSNotFound)
          {
              // Delete it
              [fileManager removeItemAtPath:[applicationDocumentsPath stringByAppendingPathComponent:filename] error:&error];
          }
      } 
  }
}

/**
 *  startRecording
 */
- (void)startRecording {
  // Ask the user if they want to delete any existing recordings. 
  // But only ask if we are NOT in 'add recording mode' 
  if ((self.session.recording != nil) && self.bAddRecordingMode == FALSE) {
    NSString *sheetTitle = NSLocalizedString(@"Overwrite existing recording(s)?", nil);
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
      NSString *destructiveTitle = NSLocalizedString(@"Overwrite Recording", nil);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:sheetTitle 
                                                             delegate:self 
                                                    cancelButtonTitle:cancelTitle 
                                               destructiveButtonTitle:destructiveTitle 
                                                    otherButtonTitles:@"Add To Recording", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
    
    return;
  }

  // Make sure we get out of 'add recording mode'
    self.bAddRecordingMode = FALSE;  
    
    // So if we get here, we will create a new recording, whether we have one or not.
    // Only the first recording will be placed in the 'session'...we will do a name search for any others as needed
    
  // Recording settings based on this post:
  // http://stackoverflow.com/questions/2149280/proper-avaudiorecorder-settings-for-recording-voice
  NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat: 16000.0], AVSampleRateKey,
                                                                              [NSNumber numberWithInt: kAudioFormatAppleIMA4], AVFormatIDKey,
                                                                              [NSNumber numberWithInt: 1], AVNumberOfChannelsKey, nil];
  
  // Uncomment the following four lines if you want the filename to include a timestamp.
  NSDate *currentDate = [NSDate date];
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"dd-MM-yyyy-HH-mm-ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
  NSString *filename = [NSString stringWithFormat:@"%@ Recording %@.aif", self.session.title, [dateFormatter stringFromDate:currentDate]];
  [dateFormatter release];

  // Create a new file to record to.
  NSString *applicationDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [applicationDirectoryPath stringByAppendingPathComponent:filename];
  
  NSDictionary *recordingValues = [NSDictionary dictionaryWithObjectsAndKeys:filePath, @"filePath", currentDate, @"creationDate", nil];
  Recording *recording = [self.librarian insertNewRecordingWithValues:recordingValues];
  
  // The session is actually responsbile for retaining the audio recorder. I'm not really happy about this decision
  // but it's one of the few ways I could think of to allow uninterrupted recording across different view controllers.
  AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:filePath] settings:recordSettings error:nil];
    audioRecorder.delegate = self;  
  self.session.audioRecorder = audioRecorder;
  self.session.recording = recording;
  
  [audioRecorder release];
  [recordSettings release];
    
    // Make sure we have the AuxSessionInfo file....used to track the recording  
    AuxSessionInfo *auxInfo = [AuxSessionInfo alloc];
    auxInfo.pListFileName = [[NSString alloc] initWithFormat:@"AuxSessionInfo %@",self.session.rank];
    //NSLog(@"AuxSessionInfo plistfilename: %@",auxInfo.pListFileName);
    if (![auxInfo initPlist]) {
        auxInfo.imaginalFileNameStart = [[NSString alloc] initWithString:self.session.recording.filePath];
        //NSLog(@"create new AuxSessionInfo file for : %@",self.session.recording.filePath);
        auxInfo.imaginalFileNameEnd = [[NSString alloc] initWithString:self.session.recording.filePath];
        auxInfo.numberOfImaginalFiles = [[NSNumber alloc] initWithInteger:1];
        auxInfo.imaginalExposureStartsOffset = [[NSNumber alloc] initWithDouble:0.0];
        auxInfo.imaginalExposureEndsOffset = [[NSNumber alloc] initWithDouble:0.0];     
        [auxInfo writeToPlist];
    };
    [auxInfo release];
    

  if ([self.session.audioRecorder record] == YES) {
      
    [Analytics logEvent:@"RECORDING STARTED" timed:YES];
      
      
      [MKInfoPanel showPanelInView:self.view 
                              type:MKInfoPanelTypeInfo 
                             title:instructionsTitle  
                          subtitle:[instructionsText stringByAppendingString:instructionsDismiss]
                         hideAfter:15];
      
      // Don't allow sleep while we are recording
      [UIApplication sharedApplication].idleTimerDisabled = YES;
      
    // Add a badge to the tab bar to indicate that we're recording.
    UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    tabBarItem.badgeValue = @"";

    
    // Update the recording button title
    [self setRecordingButtonTitle:NSLocalizedString(@"Stop Recording", nil)];
      
    // Show the pause button
      // 1-10-12 Don't implement the Pause button
    //  self.pauseButton.hidden = NO;
    
    self.beginExposureButton.enabled = YES;
    self.endExposureButton.enabled = YES;
  } else {
    NSString *alertTitle = NSLocalizedString(@"Recording Error", nil);
    NSString *alertMessage = NSLocalizedString(@"Unable to begin a recording session.", nil);
    NSString *cancelTitle = NSLocalizedString(@"Ok", nil);
    
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [alertView setTag:ALERTVIEW_RECORDING_ERROR];
    [alertView show];
    [alertView release];
  }
}

/**
 *  stopRecording
 */
- (void)stopRecording {
    
  [Analytics endTimedEvent:@"RECORDING STOPPED" withParameters:Nil];
    
  [self stopSessionRecording];
  [self setRecordingButtonTitle:NSLocalizedString(@"Start Recording", nil)];
    
    // 1-10-12 Don't implement the Pause button
    //self.pauseButton.hidden = YES;

  self.beginExposureButton.enabled = NO;
  self.endExposureButton.enabled = NO;
  
}

/**
 *  timerDidFire
 */
- (void)timerDidFire:(NSTimer *)timer {
  [self updateTimestamps];
}

/**
 *  setRecordingButtonTitle
 */
- (void)setRecordingButtonTitle:(NSString *)title {
  [self.recordingButton setTitle:title forState:UIControlStateNormal];
}

/**
 *  updateTimestamps
 */
- (void)updateTimestamps {
  if (self.session.audioRecorder.isRecording == YES) {
    [self setTextForTimestampLabel:self.elapsedTimeLabel withTimeInterval:self.session.audioRecorder.currentTime];
  }
  
  if (self.session.recording != nil) {
    [self setTextForTimestampLabel:self.beginExposureTimestampLabel withTimeInterval:[self.session.recording.imaginalExposureStartsOffset doubleValue]];
    [self setTextForTimestampLabel:self.endExposureTimestampLabel withTimeInterval:[self.session.recording.imaginalExposureEndsOffset doubleValue]];
  }
}

/**
 *  setTextForTimestampLabel:withTimeInterval
 */
- (void)setTextForTimestampLabel:(UILabel *)label withTimeInterval:(NSTimeInterval)interval {
  interval = MAX(0, interval);
  
  NSInteger hours = floor(interval / 3600);
  NSInteger minutes = floor((interval - hours * 3600) / 60);
  NSInteger seconds = floor(interval - (hours * 3600) - (minutes * 60));

  label.text = [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
}

#pragma mark - AVAudioRecorderDelegate Methods

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {    
    // Pause the recorder during the interuption
    [self.session.audioRecorder pause];
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    if (flag) {
        // NSLog(@"AVAudioRecorder Did Finish Recording Successfully");
    } else {
        //NSLog(@"AVAudioRecorder Did Finish Recording with Errors");
    }
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags {
    //NSLog(@"AVAudioRecorder End Interrupton with Flags");
    
    // Detect what mode we are in (and restart accordingly)
    if (flags == AVAudioSessionInterruptionFlags_ShouldResume) {
        //NSLog(@"Recording session was paused....resume the same session");
    } else {
        //NSLog(@"Recording session was stopped...start a new session");
    }
    
    // First, stop the recording so that we save what was being done (otherwise iOS writes over this file)
    [self stopRecording];
    
    
    // Call startRecording, with the bypass flag set, so we create a new file!!!
    self.bAddRecordingMode = TRUE;          // Let 'startRecording' know we are creating a new file
    [self startRecording];
    
    // And make sure start exposure button can't be used again!
    self.beginExposureButton.enabled = NO;
    
    // Okay, we now have multiple imaginal exposure recording files (if we didn't already!)
    // Remember which recording has the ENDING imaginal exposure
    AuxSessionInfo *auxInfo = [AuxSessionInfo alloc];
    auxInfo.pListFileName = [[NSString alloc] initWithFormat:@"AuxSessionInfo %@",self.session.rank];
    //NSLog(@"AuxSessionInfo plistfilename: %@",auxInfo.pListFileName);
    [auxInfo initPlist];
    auxInfo.imaginalFileNameEnd = [[NSString alloc] initWithString:self.session.recording.filePath];
    
    // Increment the imaginal file count
    NSInteger myCount = auxInfo.numberOfImaginalFiles.integerValue;
    myCount++;
    auxInfo.numberOfImaginalFiles = [[NSNumber alloc] initWithInteger:myCount];
    auxInfo.imaginalExposureEndsOffset = [[NSNumber alloc] initWithDouble:0.0];     
    [auxInfo writeToPlist];
    [auxInfo release];
    
    
    // Interuption is over...start the new recording
    [self.session.audioRecorder record];
}


@end
