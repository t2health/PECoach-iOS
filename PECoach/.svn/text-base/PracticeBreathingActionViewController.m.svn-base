//
//  PracticeBreathingActionViewController.m
//  PECoach
//

#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>
#import "PracticeBreathingActionViewController.h"
#import "PECoachConstants.h"
#import "UIView+Positionable.h"
#import "MKInfoPanel.h"
#import "Analytics.h"

@implementation PracticeBreathingActionViewController

#pragma mark - Properties

@synthesize exerciseButton = exerciseButton_;
//@synthesize fasterButton = fasterButton_;
//@synthesize slowerButton = slowerButton_;
@synthesize lblFast = lblFast_;
@synthesize lblSlow = lblSlow_;
@synthesize speedSlider = speedSlider_;
@synthesize lblBallCount = lblBallCount_;
@synthesize lblBallCommand = lblBallCommand_;
@synthesize ivBall;
@synthesize ivExpand, ivContract;
@synthesize ivDemo;
@synthesize ivTimer;



#pragma mark - Lifecycle

/**
 *  initWithSession:action
 */
- (id)initWithSession:(Session *)session action:(Action *)action {
  self = [super initWithSession:session action:action];
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = self.defaultSolidViewBackgroundColor;
  
  CGFloat buttonWidth = (self.view.frame.size.width - (kUIViewHorizontalInset * 2) - kUIViewHorizontalMargin) / 2;
  CGRect buttonFrame = CGRectZero;
 
  // Exercise Button
  UIButton *exerciseButton = [self buttonWithTitle:NSLocalizedString(@"Play Exercise", nil)];
  exerciseButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
  buttonFrame = exerciseButton.frame;
  buttonFrame.size.width = buttonWidth;
  buttonFrame.origin.x = (320-buttonWidth)/2;  //kUIViewHorizontalInset;
    
  exerciseButton.frame = buttonFrame;
  [exerciseButton positionAtTheBottomofView:self.view margin:kUIViewVerticalMargin];
  [exerciseButton addTarget:self action:@selector(handleExerciseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:exerciseButton];
    self.exerciseButton = exerciseButton;
    /*  06/12/2012 The slower/faster buttons are superceded by the slider
    // slower Button
    UIButton *slowerButton = [self buttonWithTitle:NSLocalizedString(@"Slower", nil)];
    slowerButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    buttonFrame = slowerButton.frame;
    buttonFrame.size.width = 2*buttonWidth/3;
    buttonFrame.origin.x = 5;
    
    slowerButton.frame = buttonFrame;
    [slowerButton positionAtTheBottomofView:self.view margin:kUIViewVerticalMargin];
    [slowerButton addTarget:self action:@selector(handleslowerfasterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Tag it as the slower button
    slowerButton.tag = kslowerButton;
    
    [self.view addSubview:slowerButton];
    self.slowerButton = slowerButton;
    
    // faster Button
    UIButton *fasterButton = [self buttonWithTitle:NSLocalizedString(@"Faster", nil)];
    fasterButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    buttonFrame = fasterButton.frame;
    buttonFrame.size.width = 2*buttonWidth/3;
    buttonFrame.origin.x = 320-2*buttonWidth/3-5;
    
    fasterButton.frame = buttonFrame;
    [fasterButton positionAtTheBottomofView:self.view margin:kUIViewVerticalMargin];
    [fasterButton addTarget:self action:@selector(handleslowerfasterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Tag it as the faster button
    fasterButton.tag = kfasterButton;
    
    [self.view addSubview:fasterButton];
    self.fasterButton = fasterButton;
    */
    // Create a slider
    CGRect frame = CGRectMake(195.0, 190.0, 200.0, 10.0);
    UISlider *sliderControl = [[UISlider alloc] initWithFrame:frame];
    [sliderControl addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [sliderControl setBackgroundColor:[UIColor clearColor]];
    sliderControl.minimumValue = kMinAnimationInterval;
    sliderControl.maximumValue = kMaxAnimationInterval;
    sliderControl.continuous = NO;
    sliderControl.value = kdefaultAnimationInterval;
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI* 0.5);
    sliderControl.transform = trans;
    [self.view addSubview:sliderControl];
    self.speedSlider = sliderControl;
    [sliderControl release];
    
    UILabel *slowLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [slowLabel setFrame:CGRectMake(272, 310, 40, 20)];
    slowLabel.backgroundColor = [UIColor lightGrayColor];
    slowLabel.font = [UIFont boldSystemFontOfSize:12.0];  
    slowLabel.textColor = [UIColor blackColor];  
    slowLabel.textAlignment = UITextAlignmentCenter;
    slowLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    slowLabel.layer.borderWidth = 1.0;
    slowLabel.layer.cornerRadius = 4.0;
    slowLabel.text = @"Slow";
    [self.view addSubview:slowLabel];
    self.lblSlow = slowLabel;
    [slowLabel release];
    
    UILabel *fastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [fastLabel setFrame:CGRectMake(272, 75, 40, 20)];
    fastLabel.backgroundColor = [UIColor lightGrayColor];
    fastLabel.font = [UIFont boldSystemFontOfSize:12.0];  
    fastLabel.textColor = [UIColor blackColor];  
    fastLabel.textAlignment = UITextAlignmentCenter;
    fastLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    fastLabel.layer.borderWidth = 1.0;
    fastLabel.layer.cornerRadius = 4.0;
    fastLabel.text = @"Fast";
    [self.view addSubview:fastLabel];
    self.lblFast = fastLabel;
    [fastLabel release];
    
    // Create the containter view
    CGRect viewRect = CGRectMake(0, 0, 320, 416);
    UIImageView *myDemo = [[UIImageView alloc] initWithFrame:viewRect];
    [myDemo setHidden:NO];
    [self.view addSubview:myDemo];
    self.ivDemo = myDemo;
    [myDemo release];
     
    
    // Add the breathing ball (and circles)
    UIImage *greenBallImage = [UIImage imageNamed:@"glass_green.png"];
    UIImageView *myBall = [[UIImageView alloc] initWithImage:greenBallImage];
	[myBall setFrame:CGRectMake(100, 100, 150, 150)];
    [myBall centerHorizontallyInView:self.ivDemo];
    [myBall centerVerticallyInView:self.ivDemo];
    [myBall setHidden:NO];
    [self.ivDemo addSubview:myBall];
    self.ivBall = myBall;
    [myBall release];
    
    // Expand Circle
    UIImage *expandImage = [UIImage imageNamed:@"expand.png"];
    UIImageView *myExpand = [[UIImageView alloc] initWithImage:expandImage];
	[myExpand setFrame:CGRectMake(100, 100, 240, 240)];
    [myExpand centerHorizontallyInView:self.ivDemo];
    [myExpand centerVerticallyInView:self.ivDemo];
    [myExpand setHidden:NO];
    [self.ivDemo addSubview:myExpand];
    self.ivExpand = myExpand;
    [myExpand release];
    
    // Contract Circle
    UIImage *contractImage = [UIImage imageNamed:@"contrast.png"];
    UIImageView *myContract = [[UIImageView alloc] initWithImage:contractImage];
	[myContract setFrame:CGRectMake(100, 100, 100, 100)];
    [myContract centerHorizontallyInView:self.ivDemo];
    [myContract centerVerticallyInView:self.ivDemo];
    [myContract setHidden:NO];
    [self.ivDemo addSubview:myContract];
    self.ivContract = myContract;
    [myContract release];
    
    // Add the Label for the count
    UILabel *myBallCount = [[UILabel alloc] initWithFrame:CGRectZero];
    [myBallCount setFrame:CGRectMake(100, 100, 150, 150)];
    myBallCount.backgroundColor = [UIColor clearColor];
    myBallCount.font = [UIFont boldSystemFontOfSize:80.0];  
    myBallCount.textColor = [UIColor blackColor];  
    myBallCount.textAlignment = UITextAlignmentCenter;
    myBallCount.shadowColor = [UIColor whiteColor];
    myBallCount.shadowOffset = CGSizeMake(0, -2);
    myBallCount.text = @"1";
    
    [self.ivDemo addSubview:myBallCount];
    self.lblBallCount = myBallCount;
    [myBallCount centerHorizontallyInView:self.ivDemo];
    [myBallCount centerVerticallyInView:self.ivDemo];
    myBallCount.hidden = NO;
    [myBallCount release];
    
    // Add the Label for the command (Inhale, Exhale, Hold)
    UILabel *myBallLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [myBallLabel setFrame:CGRectMake(100, 48, 150, 48)];
    myBallLabel.backgroundColor = [UIColor lightGrayColor];
    myBallLabel.font = [UIFont boldSystemFontOfSize:40.0];  
    myBallLabel.textColor = [UIColor blackColor];  
    myBallLabel.textAlignment = UITextAlignmentCenter;
    myBallLabel.shadowColor = [UIColor whiteColor];
    myBallLabel.shadowOffset = CGSizeMake(0, -2);
    myBallLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    myBallLabel.layer.borderWidth = 3.0;
    myBallLabel.text = @"Inhale";
    
    [self.ivDemo addSubview:myBallLabel];
    self.lblBallCommand = myBallLabel;
    [myBallLabel centerHorizontallyInView:self.ivDemo];    // Leave it at the top vertically
    myBallLabel.hidden = NO;
    [myBallLabel release];

    // Set current interval (tbd - restore from a persistent store to preserve user's preference)
    currentInterval    = kdefaultAnimationInterval;
    currentPlayRate    = kDefaultPlayRate; 
    
    // And see if we have an audio player that will let us change speeds (5.0 or greater)
    bIs5oh = NO;
    AVAudioPlayer *testPlayer = [AVAudioPlayer alloc];
    if ([testPlayer respondsToSelector:@selector(enableRate)]) {
       bIs5oh = YES;
    }
    // Kind of sloppy, but we can't release testPlayer...cuz it never gets allocated?
    
 
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [[NSNotificationCenter defaultCenter] removeObserver:self];

  self.exerciseButton = nil;
  
  [super viewDidUnload];
}

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // See if we should display our 5.0 stuff
    if (bIs5oh) {
        [self.lblFast setHidden:NO];
        [self.lblSlow setHidden:NO];
        [self.speedSlider setHidden:NO];
    } else {
        [self.lblFast setHidden:YES];
        [self.lblSlow setHidden:YES];
        [self.speedSlider setHidden:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"PRACTICE BREATHING ACTION VIEW"];
    [super viewDidAppear:animated];      
    
    [MKInfoPanel showPanelInView:self.view 
                            type:MKInfoPanelTypeInfo 
                           title:NSLocalizedString(@"Instructions",nil)  
                        subtitle:NSLocalizedString(@"This is an example.  You may need to adjust your rate of breathing because individuals breathe at different rates. The key is to slow your rate of breathing.",nil)
                       hideAfter:15];
    
    
    // Disable the Idle Timer (animation doesn't handle interuptions well!)
    [UIApplication sharedApplication].IdleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // Enable the Idle Timer 
    [UIApplication sharedApplication].IdleTimerDisabled = NO;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    if(bDemoRunning) {
        [self stopTheDemo];  
    }
    
    [super viewDidDisappear:animated];
    
}

/**
 *  dealloc
 */
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];

  [exerciseButton_ release];
  
  [super dealloc];
}
#pragma mark - Ball Animation


- (void)onTimer {
    // This method will run every 1.2 seconds by default...it can be slowered or fastered by the user:-)  
	if(!bDemoRunning) {
        // We should not get here unless the Demo is running
        // But get out just in case the timer misfires!
        return; 
    }
	timerCounter = timerCounter + 1;
	switch (timerCounter) {
		case 0:
			break;
		case 1:
			[ivDemo stopAnimating];
			if(bDemoRunning) {
				if(bVoice)
					[self preparePlayer:@"f_inhale" andNumberOfLoops:0];
				else
					[self preparePlayer:@"m_inhale" andNumberOfLoops:0];
				[player play];
                
                UIImage *uiI = [[UIImage imageNamed:@"glass_green.png"] retain];
                [ivBall setImage:uiI];
                [uiI release];
                ivBall.hidden = NO;
                lblBallCount_.hidden = NO;
                lblBallCommand_.hidden = NO;
                [self expandGreenBall];
                [self setLbltext:@"1"];
                [self setCmdtext:@"Inhale"];
				
			}
			break;
		case 2:
			if(bDemoRunning) {
                [self setLbltext:@"2"];
			}
			
			break;
		case 3:
			if(bDemoRunning) {
                [self setLbltext:@"3"];
			}
			break;
		case 4:
			if(bDemoRunning) {
                [self setLbltext:@"4"];
			}
			break;
		case 5: 
			if(bDemoRunning) {
				if(bVoice)
					[self preparePlayer:@"f_exhale" andNumberOfLoops:0];
				else
					[self preparePlayer:@"m_exhale" andNumberOfLoops:0];
				[player play];
                
                UIImage *uiI = [[UIImage imageNamed:@"glass_red.png"] retain];
                [ivBall setImage:uiI];
                [uiI release];
                [self setLbltext:@"1"];
                [self setCmdtext:@"Exhale"];
                [self contractGreenBall];
			}
			break;
		case 6: 
			if(bDemoRunning) {
                [self setLbltext:@"2"];
			}
			break;
		case 7: 
			if(bDemoRunning) {
                [self setLbltext:@"3"];
			}
			break;
		case 8: 
			if(bDemoRunning) {
                [self setLbltext:@"4"];
			}
			break;
		case 9: 
			if(bDemoRunning) {
				if(bVoice)
					[self preparePlayer:@"f_hold" andNumberOfLoops:0];  //Female Voice
				else
					[self preparePlayer:@"m_hold" andNumberOfLoops:0];
				[player play];
                
                UIImage *uiI = [[UIImage imageNamed:@"glass_yellow.png"] retain];
                [ivBall setImage:uiI];
                [uiI release];
                [self setLbltext:@"1"];
                [self setCmdtext:@"Hold"];
			}
			break;
		case 10: 
			if(bDemoRunning) {
                [self setLbltext:@"2"];
			}
			break;
		case 11: 
			if(bDemoRunning) {
                [self setLbltext:@"3"];
			}
			break;
		case 12: 
			if(bDemoRunning) {
                [self setLbltext:@"4"];
                timerCounter = 0;           // Start over at the next time interval
			} 
			break;
		case 13: 
			break;
		case 20:
			break;
		case 32:
			break;
		default:
			break;
	}
	
}

- (void)preparePlayer:(NSString *)mp3File andNumberOfLoops:(NSInteger) numberOfLoops {
    // Prepares the video and audio player
	
	if(player != nil) {
		if([player isPlaying])
			[player stop];
		[player release];
        player = nil;
	}
	
    NSString *mpPath = [[NSBundle mainBundle] pathForResource:mp3File ofType:@"mp3"]; 
    player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:mpPath] error:nil];
    
    if ([player respondsToSelector:@selector(enableRate)]) {
         bIs5oh = YES;
         //NSLog(@"Is this 5.0? %@",bIs5oh?@"YES":@"NO");
    }
    player.numberOfLoops = numberOfLoops; /* can be as many times as needed by the application   -    myExampleSound.numberOfLoops = -1; >> this will allow the file to play an infinite number of times  */
	[player setDelegate:self];  // Allows internal functions to gain player status
    
    // Let the user choose a rate of playback...this only works for iOS 5.0 and greater
    if (bIs5oh) {   // Compute and set the audio rate based on what the user has set for the animation
        // Synchronize the audio and video
        // Make these the same % as each other 
        // (but inverted cuz larger video intervals are slower but larger audio rates are quicker!)
        currentPlayRate = kDefaultPlayRate * (kdefaultAnimationInterval/currentInterval);
     
        [player setEnableRate:YES];
        [player setRate:currentPlayRate];
    }
	[player prepareToPlay]; 
	
}


- (void) expandGreenBall {
    // Expands green ball
	
	[ivBall setFrame:CGRectMake([ivBall center].x-75, [ivBall center].y-75, 150, 150)];
    [UIView beginAnimations:@"expand ball" context:nil];
    [UIView setAnimationDuration:4];
	
	[ivBall setFrame:CGRectMake([ivBall center].x-175, [ivBall center].y-175, 350, 350)];
	[UIView commitAnimations];
    [ivExpand setAlpha:(.40)];
    [ivContract setAlpha:(0)];
}

- (void) contractGreenBall {
    // Contracts green ball
	
	[ivExpand setAlpha:(0)];
	[ivContract setAlpha:(.10)];
	[ivBall setFrame:CGRectMake([ivBall center].x-175, [ivBall center].y-175, 350, 350)];
    [UIView beginAnimations:@"contract ball" context:nil];
    [UIView setAnimationDuration:4];
	[ivBall setFrame:CGRectMake([ivBall center].x-75, [ivBall center].y-75, 150, 150)];
	[UIView commitAnimations];
	
}

- (void) setLbltext:(NSString *) text {
    // Changes number inside of ball
	
	lblBallCount_.text = text;
	
}

- (void) setCmdtext:(NSString *) text {
    // Changes number inside of ball
	
	lblBallCommand_.text = text;
	
}


- (void) startAnimation {
	// Start the timer to drive the animation
	timerCounter = 0;
	ivTimer = [NSTimer scheduledTimerWithTimeInterval:currentInterval target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        
	bVoice = NO; // Male voice by default

	[ivExpand setAlpha:(0)];            // Big ring around ball 
	[ivContract setAlpha:(0)];          // Little ring inside ball
	ivDemo.animationDuration = knumOfIntervals * currentInterval;    // Animation lasts 19.2 seconds by default
	ivDemo.animationRepeatCount = 0;    // Repeats indefinitely
	ivDemo.contentMode = UIViewContentModeScaleToFill; 
	
}


#pragma mark - UI Actions


/**
 *  handleExerciseButtonTapped
 */

- (void)handleExerciseButtonTapped:(id)sender {
    
	if(bDemoRunning) {
        [self stopTheDemo];	
        
        if (bIs5oh) {
            [self.speedSlider setEnabled:YES];
            [self.lblSlow setEnabled:YES];
            [self.lblFast setEnabled:YES];
        }
	}
	
	else {
		// Start the animation
		ivBall.hidden = NO;  
        lblBallCount_.hidden = NO;
        lblBallCommand_.hidden = NO;
        
        
        [player stop];
		timerCounter = 0;
		bDemoRunning = YES;
		
        [self.exerciseButton setTitle:NSLocalizedString(@"Stop Exercise", nil) forState:UIControlStateNormal];
        
        if (bIs5oh) {
            [self.speedSlider setEnabled:NO];
            [self.lblSlow setEnabled:NO];
            [self.lblFast setEnabled:NO];
            //[self.slowerButton setEnabled:NO];
            //[self.fasterButton setEnabled:NO]            
        };
        
        // Get it going
        [self startAnimation];
        
		[Analytics logEvent:@"PRACTICE BREATHING EXERCISE STARTED"];
		[Analytics countPageView];
	}
}

- (void)stopTheDemo {
	if(bDemoRunning) {
		// We are running...stop it
        if(player != nil) {
            if([player isPlaying])
                [player stop];
            [player release];
            player = nil;
        }
        
        [self.exerciseButton setTitle:NSLocalizedString(@"Play Exercise", nil) forState:UIControlStateNormal];	
        
        // Let the user choose a rate of playback...this only works for iOS 5.0 and greater
        if (bIs5oh) {
            [self.speedSlider setHidden:NO];
            [self.speedSlider setEnabled:YES];
            [self.lblFast setHidden:NO];
            [self.lblSlow setHidden:NO];
           // [self.slowerButton setHidden:NO];
           // [self.fasterButton setHidden:NO];
           // [self.slowerButton setEnabled:YES];
           // [self.fasterButton setEnabled:YES];
        } else {
            [self.speedSlider setHidden:YES];
            [self.speedSlider setEnabled:NO];
            [self.lblFast setHidden:YES];
            [self.lblSlow setHidden:YES];
           // [self.slowerButton setHidden:YES];
           // [self.fasterButton setHidden:YES];
           // [self.slowerButton setEnabled:NO];
           // [self.fasterButton setEnabled:NO];
        }
            
        
        [ivTimer invalidate];       // Kill the interval timer
        
		bDemoRunning = NO;
		ivBall.hidden = NO;
		lblBallCount_.hidden = NO;
        lblBallCommand_.hidden = NO;
		[ivDemo stopAnimating];
		[ivExpand setAlpha:(0)];
		timerCounter = 0;
		[ivContract setAlpha:(0)];	
        
	}
}

//
// Change the pace of the breathing exercise (in response to the user manipulating the slider)
//
- (void)sliderAction:(id)sender {
    
    UISlider *ourSlider = (UISlider *)sender;
    currentInterval = ourSlider.value;    
}

//
// Change the pace of the breathing exercise (in response to the user tapping the +/- buttons
//
/*
- (void)handleslowerfasterButtonTapped:(id)sender {
    
    UIButton *ourButton = (UIButton *)sender;
    switch (ourButton.tag) {
        case kslowerButton:
            if (currentInterval < kMaxAnimationInterval)
                currentInterval = currentInterval + .1;
            [self.fasterButton setEnabled:YES];             // We're getting slower, so enable the faster button
            if (currentInterval >= kMaxAnimationInterval)   // If we are as slow as we can go, disable the slower button    
                [self.slowerButton setEnabled:NO];
            break;
            
        case kfasterButton:
            if (currentInterval > kMinAnimationInterval)
                currentInterval = currentInterval - .1;
            [self.slowerButton setEnabled:YES];
            if (currentInterval <= kMinAnimationInterval)
                [self.fasterButton setEnabled:NO];
            break;
    }    
}
*/

#pragma mark - Instance Methods

/**
 *  playerItemDidReachEnd
 */
- (void)playerItemDidReachEnd:(NSNotification *)notification {

    // Causes AVPlayerItem to loop.
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
  
}

@end
