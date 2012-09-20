//
//  AudioControlView.h
//  PECoach
//

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
