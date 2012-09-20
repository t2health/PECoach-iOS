//
//  RecordActionViewController.h
//  PECoach
//

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

