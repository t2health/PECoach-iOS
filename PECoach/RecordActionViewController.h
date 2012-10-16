//
//  RecordActionViewController.h
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
#import "ActionViewController.h"

@interface RecordActionViewController : ActionViewController<UIActionSheetDelegate, AVAudioRecorderDelegate, UIAlertViewDelegate> {
  UIButton *recordingButton_;
    //UIButton *pauseButton_;
  UILabel *elapsedTimeLabel_;

  UIButton *beginExposureButton_;
  UILabel *beginExposureTimestampLabel_;
  UIButton *endExposureButton_;
  UILabel *endExposureTimestampLabel_;

  BOOL hideImaginalExposureButtons_;
  NSTimer *timer_;
    
    BOOL bAddRecordingMode_;
    
    // Accessibility (helps VoiceOver say the relevant hints)
    NSString *instructionsTitle;
    NSString *instructionsText;
    NSString *instructionsDismiss;
}

// Properties
@property(nonatomic, retain) UIButton *recordingButton;
//@property(nonatomic, retain) UIButton *pauseButton;
@property(nonatomic, retain) UILabel *elapsedTimeLabel;

@property(nonatomic, retain) UIButton *beginExposureButton;
@property(nonatomic, retain) UILabel *beginExposureTimestampLabel;
@property(nonatomic, retain) UIButton *endExposureButton;
@property(nonatomic, retain) UILabel *endExposureTimestampLabel;

@property(nonatomic, assign) BOOL hideImaginalExposureButtons;
@property(nonatomic, retain) NSTimer *timer;

@property(nonatomic, assign) BOOL bAddRecordingMode;

@property(nonatomic, retain) NSString *instructionsTitle;
@property(nonatomic, retain) NSString *instructionsText;
@property(nonatomic, retain) NSString *instructionsDismiss;

// UIActions
- (IBAction)handleRecordingButtonTapped:(id)sender;
//- (IBAction)handlePauseButtonTapped:(id)sender;
- (IBAction)handleBeginExposureButtonTapped:(id)sender;
- (IBAction)handleEndExposureButtonTapped:(id)sender;

// Instance Methods
- (void)removeExistingRecording;
- (void)startRecording;
- (void)stopRecording;
- (void)setRecordingButtonTitle:(NSString *)title;
- (void)timerDidFire:(NSTimer *)timer;
- (void)updateTimestamps;
- (void)setTextForTimestampLabel:(UILabel *)label withTimeInterval:(NSTimeInterval)interval;

@end

