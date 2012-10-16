//
//  AudioControlView.h
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
#import <UIKit/UIKit.h>

@class AVAudioPlayer;
@class Session;

@interface AudioControlView : UIView<AVAudioPlayerDelegate> {
    Session *session_;
    NSString *audioFilePathCurrent_;
    NSString *audioFilePathFirst_;
    NSString *audioFilePathLast_;
    AVAudioPlayer *audioPlayer_;
    NSTimer *timer_;
    NSTimeInterval playbackOffset_;
    NSTimeInterval restartOffset_;
    NSTimeInterval restartSliderOffset_;
    NSTimeInterval playbackDuration_;
    NSTimeInterval previousDurations_;
    NSTimeInterval totalPlaybackDuration_;
    
    NSNumber *sessionRank;
    
    // Save copies of what we are called with (so it can be used for subsequent files)  
    NSTimeInterval originalStartOffset_;
    NSTimeInterval originalEndOffset_;
    
    UISlider *playbackSlider_;
    UIButton *restartButton_;
    UIButton *controlButton_;
    UILabel *infoLabel_;
    UILabel *elapsedLabel_;
    UILabel *remainingLabel_;
    //UILabel *audioFileLabel_;
    
    /* 01/25/2012 Multiple Audio File Controls
     UILabel *audioFileCounter_;
     UIButton *prevButton_;
     UIButton *nextButton_;
     UILabel *multiAudioLabel_;
     */
    
    NSMutableArray *arrayRecordingFiles_;
    
    NSInteger nCurrentFile_, nTotalFiles_;  
}

// Properties
@property(nonatomic, retain) Session *session;
@property(nonatomic, copy) NSString *audioFilePathCurrent;
@property(nonatomic, copy) NSString *audioFilePathFirst;
@property(nonatomic, copy) NSString *audioFilePathLast;
@property(nonatomic, retain) AVAudioPlayer *audioPlayer;
@property(nonatomic, assign) NSTimer *timer;
@property(nonatomic, assign) NSTimeInterval playbackOffset;
@property(nonatomic, assign) NSTimeInterval restartOffset;
@property(nonatomic, assign) NSTimeInterval restartSliderOffset;
@property(nonatomic, assign) NSTimeInterval playbackDuration;
@property(nonatomic, assign) NSTimeInterval previousDurations;
@property(nonatomic, assign) NSTimeInterval totalPlaybackDuration;
@property(nonatomic, assign) NSTimeInterval originalStartOffset;
@property(nonatomic, assign) NSTimeInterval originalEndOffset;
@property(nonatomic, retain) NSNumber *sessionRank;

@property(nonatomic, retain) UISlider *playbackSlider;
@property(nonatomic, retain) UIButton *restartButton;
@property(nonatomic, retain) UIButton *controlButton;
@property(nonatomic, retain) UILabel *infoLabel;
@property(nonatomic, retain) UILabel *elapsedLabel;
@property(nonatomic, retain) UILabel *remainingLabel;
//@property(nonatomic, retain) UILabel *audioFileLabel;


/* 01/25/2012 Multiple Audio File Controls
 @property(nonatomic, retain) UILabel *audioFileCounter;
 @property(nonatomic, retain) UIButton *prevButton;
 @property(nonatomic, retain) UIButton *nextButton;
 @property(nonatomic, retain) UILabel *multiAudioLabel;
 */

@property NSInteger nCurrentFile;
@property NSInteger nTotalFiles;
@property(nonatomic, retain) NSMutableArray *arrayRecordingFiles;

// Initializers
- (id)initWithFrame:(CGRect)frame filePath:(NSString *)path;

// UI Handlers
- (void)handlePrevAudioFileButtonTapped:(id)sender;
- (void)handleNextAudioFileButtonTapped:(id)sender;
- (void)handleRestartButtonTapped:(id)sender;
- (void)handleControlButtonTapped:(id)sender;
- (void)handlePlaybackSliderUpdated:(id)sender;
- (void)loadNewAudioFile;           // Not really a handler, but a helper for the handlers!

// Instance Methods
- (void)startAudioPlayback;
- (void)stopAudioPlayback;
- (void)loadAudioFileAtPath:(NSString *)path startOffset:(NSTimeInterval)startOffset endOffset:(NSTimeInterval)endOffset lastImaginalFilePath:(NSString *)pathLast;
- (void)updateTimestamps;

@end
