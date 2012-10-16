//
//  PracticeBreathingActionViewController.h
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
