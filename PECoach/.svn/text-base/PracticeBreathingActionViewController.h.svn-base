//
//  PracticeBreathingActionViewController.h
//  PECoach
//

#import "ActionViewController.h"
#import <AVFoundation/AVFoundation.h>

// Tags to identify the slower/faster animation speed buttons
//#define kslowerButton     1
//#define kfasterButton     2

// Default animation interval (secs)
#define kdefaultAnimationInterval   1.2
#define kMaxAnimationInterval       2.4
#define kMinAnimationInterval       0.6
#define knumOfIntervals             16

// Audio play rate(s)
#define kDefaultPlayRate            1.0
#define kSlowestPlayRate            0.5
#define kFastestPlayRate            2.0

@interface PracticeBreathingActionViewController : ActionViewController <UITextFieldDelegate, UIScrollViewDelegate, AVAudioPlayerDelegate>{

    UIButton *exerciseButton_;
    //UIButton *fasterButton_;
    //UIButton *slowerButton_;
    UISlider *speedSlider_;
    UILabel *lblFast_;
    UILabel *lblSlow_;
    UIImageView *ivBall;
	UILabel *lblBallCount_;
	UILabel *lblBallCommand_;
	UIImageView *ivContract;
	UIImageView *ivExpand;
	UIImageView *ivDemo;
    NSTimer *ivTimer;
    

    AVAudioPlayer *player;
	NSInteger timerCounter;
    CGFloat  currentInterval;
    CGFloat  currentPlayRate;
	BOOL bDemoRunning;
	BOOL bVoice;            // NO - Male, YES - Female
    BOOL bIs5oh;            // Are we iOS 5.0 or greater...search the code for what this really means
}

// Properties
@property(nonatomic, retain) UIButton *exerciseButton;
//@property(nonatomic, retain) UIButton *slowerButton;
//@property(nonatomic, retain) UIButton *fasterButton;
@property(nonatomic, retain) UILabel *lblFast;
@property(nonatomic, retain) UILabel *lblSlow;
@property(nonatomic, retain) UISlider *speedSlider;
@property(nonatomic, retain) UILabel *lblBallCount;
@property(nonatomic, retain) UILabel *lblBallCommand;
@property(nonatomic, retain) UIImageView *ivBall;
@property(nonatomic, retain) UIImageView *ivExpand;
@property(nonatomic, retain) UIImageView *ivContract;
@property(nonatomic, retain) UIImageView *ivDemo;
@property(nonatomic, retain) NSTimer *ivTimer;

// UI Actions
- (void)handleExerciseButtonTapped:(id)sender;
//- (void)handleslowerfasterButtonTapped:(id)sender;
- (void)sliderAction:(id)sender;

// Instance Methods
- (void)playerItemDidReachEnd:(NSNotification *)notification;

// Animation
- (void) preparePlayer:(NSString *)mp3File andNumberOfLoops:(NSInteger) numberOfLoops;
- (void) expandGreenBall;
- (void) contractGreenBall;
- (void) setLbltext:(NSString *) text;
- (void) setCmdtext:(NSString *) text;

@end
