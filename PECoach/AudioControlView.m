//
//  AudioControlView.m
//  PECoach
//

#import "AudioControlView.h"
#import "Analytics.h"
#import "Session.h"
#import "PECoachConstants.h"
#import "UIView+Positionable.h"
#import "AuxSessionInfo.h"

@implementation AudioControlView

#pragma mark - Properties

@synthesize session = session_;
@synthesize audioFilePathCurrent = audioFilePathCurrent_;
@synthesize audioFilePathFirst = audioFilePathFirst_;
@synthesize audioFilePathLast = audioFilePathLast_;
@synthesize audioPlayer = audioPlayer_;
@synthesize timer = timer_;
@synthesize playbackOffset = playbackOffset_;
@synthesize restartOffset = restartOffset_;
@synthesize restartSliderOffset = restartSliderOffset_;
@synthesize playbackDuration = playbackDuration_;
@synthesize previousDurations = previousDurations_;
@synthesize totalPlaybackDuration = totalPlaybackDuration_;
@synthesize originalStartOffset = originalStartOffset_;
@synthesize originalEndOffset = originalEndOffset_;
@synthesize sessionRank = sessionRank_;

@synthesize playbackSlider = playbackSlider_;
@synthesize restartButton = restartButton_;
@synthesize controlButton = controlButton_;
@synthesize elapsedLabel = elapsedLabel_;
@synthesize remainingLabel = remainingLabel_;
@synthesize infoLabel = infoLabel_;
//@synthesize audioFileLabel = audioFileLabel_;


/* 01/25/2012 Multiple Audio File Controls
 @synthesize audioFileCounter = audioFileCounter_;
 @synthesize prevButton = prevButton_;
 @synthesize nextButton = nextButton_;
 @synthesize multiAudioLabel = multiAudioLabel_;
 */

@synthesize nTotalFiles = nTotalFiles_;
@synthesize nCurrentFile = nCurrentFile_;
@synthesize arrayRecordingFiles = arrayRecordingFiles_;

#pragma mark - Lifecycle

/**
 *  initWithFrame:filePath:startOffset:endOffset
 */
- (id)initWithFrame:(CGRect)frame filePath:(NSString *)path {
    self = [super initWithFrame:frame];
    if (self != nil) {    
        UIFont *labelFont = [UIFont boldSystemFontOfSize:13.0];
        CGFloat labelWidth = 50.0;
        CGFloat sliderHeight = 25.0;
        
        
        elapsedLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, sliderHeight)];
        [elapsedLabel_ setBackgroundColor:[UIColor clearColor]];
        [elapsedLabel_ setTextColor:[UIColor whiteColor]];
        [elapsedLabel_ setFont:labelFont];
        [elapsedLabel_ setTextAlignment:UITextAlignmentCenter];
        [self addSubview:elapsedLabel_];
        
        playbackSlider_ = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - (labelWidth * 2), sliderHeight)];
        [playbackSlider_ setUserInteractionEnabled:NO];
        [playbackSlider_ addTarget:self action:@selector(handlePlaybackSliderUpdated:) forControlEvents:UIControlEventValueChanged];
        [playbackSlider_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [playbackSlider_ setThumbImage:[UIImage imageNamed:@"playbackSliderThumb.png"] forState:UIControlStateNormal];
        [playbackSlider_ positionToTheRightOfView:elapsedLabel_ margin:0.0];
        [self addSubview:playbackSlider_];
        
        remainingLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, sliderHeight)];
        [remainingLabel_ setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [remainingLabel_ positionToTheRightOfView:playbackSlider_ margin:0.0];
        [remainingLabel_ setBackgroundColor:[UIColor clearColor]];
        [remainingLabel_ setTextColor:[UIColor whiteColor]];
        [remainingLabel_ setFont:labelFont];
        [remainingLabel_ setTextAlignment:UITextAlignmentCenter];
        [self addSubview:remainingLabel_];
        
        // Should really move this button code into a UIButton category.
        controlButton_ = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [controlButton_ setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [controlButton_ setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundNormalMedium.png"] forState:UIControlStateNormal];
        [controlButton_ setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundHighlightedMedium.png"] forState:UIControlStateHighlighted];
        [controlButton_ setFrame:CGRectMake(0.0, 0.0, kUIButtonSizeMediumWidth, kUIButtonDefaultHeight)];
        [controlButton_ setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
        [controlButton_ setTitleColor:[UIColor colorWithRed:28.0/255.0 green:39.0/255.0 blue:57.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [controlButton_ setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [controlButton_ setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [controlButton_ setTitleShadowColor:[UIColor colorWithWhite:0.9 alpha:1.0] forState:UIControlStateNormal];
        [controlButton_ setTitleShadowColor:[UIColor colorWithWhite:0.3 alpha:1.0] forState:UIControlStateHighlighted];
        [controlButton_ addTarget:self action:@selector(handleControlButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        controlButton_.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        controlButton_.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
        [controlButton_ positionBelowView:playbackSlider_ margin:kUIViewVerticalMargin];
        [controlButton_ centerHorizontallyInView:self];
        [self addSubview:controlButton_];
        
        // Navigate to the previous audio file
        restartButton_ = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [restartButton_ setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [restartButton_ setBackgroundImage:[UIImage imageNamed:@"infoBarLeftArrow@2x.png"] forState:UIControlStateNormal];
        [restartButton_ setFrame:CGRectMake(0.0, 0.0, kUIButtonSizeSmallWidth, 60)];
        [restartButton_ addTarget:self action:@selector(handlePrevAudioFileButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [restartButton_ positionBelowView:playbackSlider_ margin:0];
        [restartButton_ positionToTheLeftOfView:controlButton_ margin:0];
        [self addSubview:restartButton_];
        restartButton_.hidden = YES;
        
        
        labelFont = [UIFont boldSystemFontOfSize:14.0];
        infoLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, labelFont.lineHeight)];
        [infoLabel_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [infoLabel_ setBackgroundColor:[UIColor clearColor]];
        [infoLabel_ setTextColor:[UIColor whiteColor]];
        [infoLabel_ setFont:labelFont];
        [infoLabel_ setText:NSLocalizedString(@"Audio recording not found.", nil)];
        [infoLabel_ setTextAlignment:UITextAlignmentCenter];
        
        [infoLabel_ centerHorizontallyInView:self];
        [infoLabel_ positionBelowView:playbackSlider_ margin:kUIViewVerticalMargin];
        [self addSubview:infoLabel_];
        
        /*
         // Display the file size (may be temporary but is useful for determining resource usage)    
         labelFont = [UIFont boldSystemFontOfSize:14.0];
         audioFileLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, labelFont.lineHeight*2)];
         [audioFileLabel_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
         [audioFileLabel_ setBackgroundColor:[UIColor clearColor]];
         [audioFileLabel_ setTextColor:[UIColor whiteColor]];
         [audioFileLabel_ setFont:labelFont];
         [audioFileLabel_ setText:NSLocalizedString(@"File Size: ", nil)];
         [audioFileLabel_ setTextAlignment:UITextAlignmentCenter];
         
         [audioFileLabel_ centerHorizontallyInView:self];
         [audioFileLabel_ positionBelowView:controlButton_ margin:kUIViewVerticalMargin];
         [self addSubview:audioFileLabel_];
         */  
        
        /* 01/25/2012 Multiple Audio File Controls
         *  All of these controls are for manipulation of multiple audio files...
         *  As of this date, all of these should be transparent to the user and thus these controls are being removed
         *  I am leaving the code in here in case it is ever needed
         *  Look for the above dateline for where the code needs to be restored!
         
         
         // Only display these controls if we have multiple audio files (see loadAudioFileAtPath)
         // Display the # of audio files (and which one we are display)...only if there is more than 1    
         labelFont = [UIFont boldSystemFontOfSize:14.0];
         audioFileCounter_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, labelFont.lineHeight*2)];
         [audioFileCounter_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
         [audioFileCounter_ setBackgroundColor:[UIColor clearColor]];
         [audioFileCounter_ setTextColor:[UIColor whiteColor]];
         [audioFileCounter_ setFont:labelFont];
         [audioFileCounter_ setLineBreakMode:UILineBreakModeWordWrap];
         [audioFileCounter_ setNumberOfLines:3];
         //audioFileCounter_.text = [NSString stringWithFormat:@"(File %d of %d)",nCnt,nTotal];
         [audioFileCounter_ setTextAlignment:UITextAlignmentCenter];
         
         [audioFileCounter_ centerHorizontallyInView:self];
         [audioFileCounter_ positionBelowView:controlButton_ margin:0];
         [self addSubview:audioFileCounter_];
         audioFileCounter_.hidden = YES;
         
         // Navigate to the previous audio file
         prevButton_ = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
         [prevButton_ setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
         [prevButton_ setBackgroundImage:[UIImage imageNamed:@"infoBarLeftArrow@2x.png"] forState:UIControlStateNormal];
         [prevButton_ setFrame:CGRectMake(0.0, 0.0, kUIButtonSizeSmallWidth, 60)];
         [prevButton_ addTarget:self action:@selector(handlePrevAudioFileButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
         
         [prevButton_ positionBelowView:playbackSlider_ margin:0];
         [prevButton_ positionToTheLeftOfView:controlButton_ margin:0];
         [self addSubview:prevButton_];
         prevButton_.hidden = YES;
         
         // Navigate to the next audio file
         nextButton_ = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
         [nextButton_ setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
         [nextButton_ setBackgroundImage:[UIImage imageNamed:@"infoBarRightArrow@2x.png"] forState:UIControlStateNormal];
         [nextButton_ setFrame:CGRectMake(0.0, 0.0, kUIButtonSizeSmallWidth, 60)];
         //[nextButton_ setTitleShadowColor:[UIColor colorWithWhite:0.9 alpha:1.0] forState:UIControlStateNormal];
         //[nextButton_ setTitleShadowColor:[UIColor colorWithWhite:0.3 alpha:1.0] forState:UIControlStateHighlighted];
         [nextButton_ addTarget:self action:@selector(handleNextAudioFileButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
         
         [nextButton_ positionBelowView:playbackSlider_ margin:0];
         [nextButton_ positionToTheRightOfView:controlButton_  margin:0];
         [self addSubview:nextButton_];
         nextButton_.hidden = YES;
         
         // Let the user know what is going on!     
         multiAudioLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
         multiAudioLabel_.backgroundColor = [UIColor lightGrayColor];
         multiAudioLabel_.font = [UIFont systemFontOfSize:14.0];
         multiAudioLabel_.layer.cornerRadius = 4.0;
         multiAudioLabel_.numberOfLines = 5;
         multiAudioLabel_.textAlignment = UITextAlignmentCenter;
         multiAudioLabel_.text = NSLocalizedString(@"  There are multiple recording files for   \nthis session.  Please use the 'arrows'\nto listen to each recording file.",nil);
         multiAudioLabel_.textColor = [UIColor blackColor];
         [multiAudioLabel_ sizeToFit];
         
         [self addSubview:multiAudioLabel_];
         
         //[multiAudioLabel_ positionBelowView:audioFileCounter_ margin:kUIViewVerticalMargin];
         [multiAudioLabel_ positionAboveView:playbackSlider_ margin:kUIViewVerticalMargin];
         [multiAudioLabel_ centerHorizontallyInView:self];
         multiAudioLabel_.hidden = YES;
         
         */
        
        // We will assume we only have 1 file
        nCurrentFile_ = nTotalFiles_ = 0;
    }
    
    return self;
}


/**
 *  dealloc
 */
- (void)dealloc {
    [audioPlayer_ stop];
    [audioPlayer_ release];
    
    [audioFilePathFirst_ release];
    [audioFilePathLast_ release];
    
    [timer_ invalidate];
    
    [session_ release];
    [playbackSlider_ release];
    [restartButton_ release];
    [controlButton_ release];
    [elapsedLabel_ release];
    [remainingLabel_ release]; 
    
    // [audioFileLabel_ release];
    
    /* 01/25/2012 Multiple Audio File Controls
     [audioFileCounter_ release];
     [nextButton_ release];
     [prevButton_ release];
     [multiAudioLabel_ release];
     */
    
    [arrayRecordingFiles_ release];
    
    [super dealloc];
}

#pragma mark - AVAudioPlayerDelegate Methods

/**
 *  audioPlayerDidFinishPlaying:successfully
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    // Check to see where we are at...
    // If there are more files to play, automatically start playing the next one
    if ((nTotalFiles_ > 0) && (nCurrentFile_ < nTotalFiles_)) {
        nCurrentFile_++;
        [self loadNewAudioFile];
        [self startAudioPlayback];
    } else {
        // If there is nothing more to play, set the button back to Play
        [self.controlButton setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
        nCurrentFile_ = 1;          // Back to the start!
        self.previousDurations = 0.0;
        [self.playbackSlider setValue:self.playbackSlider.minimumValue];
        [self loadNewAudioFile];
    }
    
}

#pragma mark - UI Handlers

// Helper method for button handlers
- (void)loadNewAudioFile
{    
    
    /* 01/25/2012 Multiple Audio File Controls
     // Update the label so the user knows how many files to listen to
     audioFileCounter_.text = [NSString stringWithFormat:@"(File %@ %d of %d)",[arrayRecordingFiles_ objectAtIndex:nCurrentFile_-1],  nCurrentFile_,nTotalFiles_];
     */
    
    // Before we let the previous file go...grab its duration (to be used to keep our time slider accurate
    if (nCurrentFile_ > 1)  // But only if there is a previous file!
        self.previousDurations += self.audioPlayer.duration;
    
    //[self stopAudioPlayback];       // Make sure the current file is stopped
    [self.audioPlayer pause];
    
    // And switch to this new file 
    // Build the full filepath
    NSString *applicationDirectoryPath = 
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *newFile = [applicationDirectoryPath stringByAppendingPathComponent:[arrayRecordingFiles_ objectAtIndex:nCurrentFile_-1]];
    //NSLog(@"loadNewAudioFile is calling loadAudioFileAtPath");
    [self loadAudioFileAtPath:newFile startOffset:originalStartOffset_ endOffset:originalEndOffset_ lastImaginalFilePath:audioFilePathLast_];
}

/**
 *  prevAudioFileButtonTapped
 */
- (void)handlePrevAudioFileButtonTapped:(id)sender {
    if (nCurrentFile_ > 1) 
    {
        nCurrentFile_--;
        [self loadNewAudioFile];
    }
}

/**
 *  nextAudioFileButtonTapped
 */
- (void)handleNextAudioFileButtonTapped:(id)sender {
    if (nCurrentFile_ < nTotalFiles_)
    {
        nCurrentFile_++;
        [self loadNewAudioFile];
    }
    
}/**
  *  handleRestartButtonTapped
  */
- (void)handleRestartButtonTapped:(id)sender {
    // Not implemented...purpose is to let the user go back to the start...really need full controls (TBD)
}
/**
 *  handleControlButtonTapped
 */
- (void)handleControlButtonTapped:(id)sender {
    if (self.audioPlayer.isPlaying == YES) {
        //NSLog(@"AudioControlView.handleControlButtonTapped: call stopAudioPlayback");
        [self stopAudioPlayback];
    } else {
        [self startAudioPlayback];
    }
}
/**
 *  handlePlaybackSliderUpdated
 */
- (void)handlePlaybackSliderUpdated:(id)sender {
    self.audioPlayer.currentTime = self.playbackSlider.value;
    [self updateTimestamps];
}


#pragma mark - Instance Methods

/**
 *  startAudioPlayback
 */
- (void)startAudioPlayback {
    
    // Disable the Idle Timer
    //NSLog(@"app is active...pre IdleTimerDisabled: %@",[UIApplication sharedApplication].idleTimerDisabled?@"YES":@"NO" );
    [UIApplication sharedApplication].IdleTimerDisabled = YES;
    
    if (self.audioPlayer.isPlaying == NO) {
        self.audioPlayer.currentTime = (self.playbackSlider.value < self.playbackSlider.maximumValue ? self.playbackSlider.value - self.previousDurations : self.playbackSlider.minimumValue);
        [self.audioPlayer play];
        [self.controlButton setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
    }
}

/**
 *  stopAudioPlayback
 */
- (void)stopAudioPlayback {
    //NSLog(@"AudioControlView.stopAudioPlayback");
    
    // Enable the Idle Timer
    //NSLog(@"app is active...pre IdleTimerDisabled: %@",[UIApplication sharedApplication].idleTimerDisabled?@"YES":@"NO" );
    [UIApplication sharedApplication].IdleTimerDisabled = NO;
    
    [self.audioPlayer pause];
    [self.controlButton setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
    
    // Save where we were at...   
    AuxSessionInfo *auxInfo = [AuxSessionInfo alloc];
    auxInfo.pListFileName = [[NSString alloc] initWithFormat:@"AuxSessionInfo %@",self.sessionRank];
    //NSLog(@"AuxSession File Name: %@",auxInfo.pListFileName);
    [auxInfo initPlist];
    
    // Set the current file (and the position within that file)
    auxInfo.currentFileName = self.audioFilePathCurrent;
    auxInfo.currentOffset = [NSNumber numberWithDouble:self.audioPlayer.currentTime];     
    [auxInfo writeToPlist];
    [auxInfo release];
   // NSLog(@"Stopped:  FileName: %@  Position: %@",auxInfo.currentFileName, auxInfo.currentOffset);
    
}

/**
 *  loadAudioFileAtPath
 *
 * 01/12/2012
 * This App was originally coded with the notion that there would only be 1 (one) recording file per session.  But the iPhone
 * stops the recording when an incoming phone call arrives.  So the code has been modified to handle multiple recording files.
 * Most of this new implementation is in this class and the majority of that is in this method.
 *
 * Essentially, we are tracking all recording files created for each session.  They have names of the form:
 *          Session 1 Recording 2012-01-12-11-21-52.aif
 *
 * Since the last part of the filename is a timestamp (yyyy-mm-dd-hh-mm-ss), it is easy to put all of these files into sequence
 * so that they are played back in the proper order.
 *
 * One nonobvious challenge is that the file that is initially passed to this method, is actually the last one created.  So, if
 * we are dealing with multiple files, the code below makes the switch to use the first file instead of the last.
 * EXCEPT if we are dealing with Imaginal Files
 * In this case we receive the name of the Imaginal File to play first (now)
 *
 * ALSO, we do allow the user to start listening where they left off.  So you'll see code below to take that into account also.
 *
 * This hopefully provides a framework for someone to maintain this code in the future!
 */
- (void)loadAudioFileAtPath:(NSString *)path startOffset:(NSTimeInterval)startOffset endOffset:(NSTimeInterval)endOffset lastImaginalFilePath:(NSString *)pathLast{
    //NSLog(@"loadAudioFileAtPath ENTRY nTotalFiles: %d",nTotalFiles_);
    [self.timer invalidate];
    self.timer = nil;
    BOOL bPickImaginalFile = FALSE;
    
    //NSLog(@"First Imaginal: %@  Last Imaginal: %@",path, pathLast);
    
    // Check if we want to specify the first file to play (used for imaginal recordings)
    if (nTotalFiles_ < 0)
        bPickImaginalFile = TRUE;
    
    // Grab the path so that we can replace it below (if we decide it is the last file and not the first!)
    NSString *pathToPlay = path;
    
    // Indicate we are not restarting...will determine that later
    self.restartOffset = 0.0;
    
    // We need to look for multiple files...
    // But only if we have at least 1 files and only if we haven't already done this!
    // Note:  0 means look for all files and then start play with the first one (chronologically)
    //       -1 means look for all files but start with the specified file, then proceed chronologically
    if ((path != nil) && (nTotalFiles_ < 1))
    {
        
        /* 01/25/2012 Multiple Audio File Controls
         // Make sure the multi file recording stuff is hidden
         audioFileCounter_.hidden = YES;
         nextButton_.hidden = YES;
         prevButton_.hidden = YES;
         multiAudioLabel_.hidden = YES;
         */
        
        
        // Save these...if we are dealing with Imaginal files, these are our first and last files.
        self.audioFilePathFirst = path;
        self.audioFilePathLast = pathLast;
        self.previousDurations = 0.0;
        
        // Find the session we are in from the filename of this recording
        // Look backwards from the end to the first '/' to just get the file name
        NSRange posFileName = [path rangeOfString:@"/" options:NSBackwardsSearch];
        if (posFileName.location != NSNotFound)
        {
            // We found the filename...extract the first 16 characters...we'll search for recordings with this prefix
            NSRange newRange;
            newRange.location = posFileName.location+1;
            newRange.length = 16;
            NSString *filePrefix = [path substringWithRange:newRange];  
            
            // Now look for all of the files and find the ones with this prefix
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSString *applicationDocumentsPath = 
            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            
            // Reset our index and total # of files...should have been done...but let's make sure
            nCurrentFile_ = nTotalFiles_ = 0;
            self.totalPlaybackDuration = 0.0;
            arrayRecordingFiles_ = [[NSMutableArray alloc] init];
            long long totalFileSize = 0.0;
            NSError *error = nil;
            for (NSString *filename in [fileManager contentsOfDirectoryAtPath:applicationDocumentsPath error:&error]) {
                // Only use files with our filePrefix
                NSRange prefixRange = [filename rangeOfString:filePrefix];
                if (prefixRange.location != NSNotFound)
                {
                    [arrayRecordingFiles_ addObject:filename];
                    nTotalFiles_++;
                    // And find out how long this file is (in seconds)   
                    NSString *fullPath = [applicationDocumentsPath stringByAppendingPathComponent:filename];
                    NSURL *url = [NSURL fileURLWithPath:fullPath];
                    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                    self.totalPlaybackDuration += CMTimeGetSeconds(audioAsset.duration);      // Determine and display the size of this file
                    
                    NSError *attributesError=nil;
                    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&attributesError];
                    
                    // Log how big the file is (seconds and KB/MB)
                    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                    long long fileSize = [fileSizeNumber longLongValue];
                    totalFileSize += fileSize;
                }
            }
            
            // Log how big this file is (time and size)
            NSString *ourFileSize;
            if (totalFileSize < 1000000) {
                ourFileSize = [NSString stringWithFormat:@"RECORDING FILE SIZE: %lld KB Duration: %0.2f mins", totalFileSize/1000, self.totalPlaybackDuration/60];
            } else {          
                ourFileSize = [NSString stringWithFormat:@"RECORDING FILE SIZE: %lld MB Duration: %0.2f mins", totalFileSize/1000000, self.totalPlaybackDuration/60];
            }
            //NSLog(@"%@",ourFileSize);
            [Analytics logEvent:ourFileSize];
            
            nCurrentFile_ = 1;      // We have at least one file...set this as the default
            // Only deal with multiple files if we have multiple files! (>1)
            if (nTotalFiles_>1)
            {
                
                /* 01/25/2012 Multiple Audio File Controls
                 // Update the label so the user knows how many files to listen to (1 of x)
                 audioFileCounter_.text = [NSString stringWithFormat:@"(File %@ %d of %d)",[arrayRecordingFiles_ objectAtIndex:0],  1,nTotalFiles_];
                 
                 // Make sure the multi file recording stuff will be shown
                 // tbd - Hide all of these eventually
                 audioFileCounter_.hidden = NO;
                 nextButton_.hidden = NO;
                 prevButton_.hidden = NO;
                 //multiAudioLabel_.hidden = NO;
                 */
                
                // Make sure the files are in ascending order by name 
                // (which is actually by date because they are named with a date-time embedded!)
                // We want the user to hear the recordings in the order they were made!)
                [arrayRecordingFiles_ sortUsingSelector:@selector(compare:)];
                
                // And remember the interval parms (we'll need them when we play the other files)
                originalStartOffset_ = startOffset;
                originalEndOffset_ = endOffset;
                
                // And the file we were just passed was actually the last file...let's get the first one!
                NSString *applicationDirectoryPath = 
                [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                
                // So which file do we start with?
                nCurrentFile_ = 0;
                
                // Do we want to pick an imaginal file?
                if (bPickImaginalFile == FALSE)
                {
                    // Not using an imaginal file, so...
                    // Check to see if they were listening before...if so, start them where they left off
                    AuxSessionInfo *auxInfo = [AuxSessionInfo alloc];
                    auxInfo.pListFileName = [[NSString alloc] initWithFormat:@"AuxSessionInfo %@",self.sessionRank];
                    //NSLog(@"checking to see if we can restart...fn: %@",auxInfo.pListFileName);
                    BOOL bAuxFileExists_ = [auxInfo initPlist];
                    
                    // Only continue if we have an auxiliary file
                    if (bAuxFileExists_) {
                       // NSLog(@"auxiliary file found...continue possible restart...");
                        // ...and only if the current file exists
                        if (auxInfo.currentFileName != nil) {
                            //NSLog(@"..RESTARTING where we left off! ===============");
                            pathToPlay = auxInfo.currentFileName;
                            self.restartOffset = [auxInfo.currentOffset doubleValue];   // Offset into the file..when we find it
                            self.restartSliderOffset = 0.0;                     // Slider offset to track total recording listened to
                            
                            // And one final thing...find the index for this file so that we can continue on after this file completes
                            // AND add up the total duration before this file so we can set the progress slider appropriately
                            NSRange nRange;
                            for (NSInteger iCnt=0; iCnt<nTotalFiles_; iCnt++) {
                                // Is this the Current file?
                                NSString *testPath = [applicationDirectoryPath stringByAppendingPathComponent:[arrayRecordingFiles_ objectAtIndex:iCnt]];
                                
                                nRange = [testPath rangeOfString:pathToPlay];
                                if (nRange.location != NSNotFound) {
                                    //NSLog(@"Restart File index: %d",iCnt);
                                    nCurrentFile_ = iCnt+1;
                                    self.previousDurations = self.restartSliderOffset;
                                    self.restartSliderOffset += self.restartOffset;  // Add our contribution to the duration
                                    break;
                                }
                                
                                // If we get here...the file was not the one we were looking for...
                                // But we need its duration to keep our slider current
                                NSURL *url = [NSURL fileURLWithPath:testPath];
                                AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                                self.restartSliderOffset += CMTimeGetSeconds(audioAsset.duration);  
                            }
                            
                            //NSLog(@"Restart for Session #: %@ at position: %f",self.sessionRank,self.restartSliderOffset);
                            
                        }
                        else {
                            NSLog(@"Whoops...no file..cannot restart");
                        }
                    } else {
                        NSLog(@"Restart info does not exist...cannot restart");
                    }
                    
                    if (self.restartOffset == 0.0) {
                        // No...just start with the first file
                        nCurrentFile_ = 1;
                        pathToPlay = [applicationDirectoryPath stringByAppendingPathComponent:[arrayRecordingFiles_ objectAtIndex:nCurrentFile_-1]]; 
                    }
                    
                    
                    
                } else {
                    // We need to find the first imaginal file (and the rest of them for that matter)
                    // path:        Has the first imaginal file
                    // pathLast:    Has the last imaginal file 
                    self.totalPlaybackDuration = 0.0;                   // We'll also determine our playback duration
                    
                    // NOTE:  All of the AVURLAsset stuff below should really be run in another thread.  BUT, performance is just not
                    // that critical in this App so I took a shortcut to avoid the complexity of writing (and maintaining that code).
                    
                    NSRange nRange;
                    BOOL bIsFirstImaginal = FALSE;      // Current file IS the First Imaginal
                    BOOL bHaveFirstImaginal = FALSE;    // At some point we FOUND the First Imaginal
                    BOOL bIsLastImaginal = FALSE;       // Ditto the above
                    BOOL bHaveLastImaginal = FALSE;
                    for (NSInteger iCnt=0; iCnt<nTotalFiles_; iCnt++) {
                        // Is this the Imaginal File?
                        NSString *testPath = [applicationDirectoryPath stringByAppendingPathComponent:[arrayRecordingFiles_ objectAtIndex:iCnt]];
                        
                        // Look for the first imaginal file?
                        if ((nCurrentFile_ == 0) && !bHaveFirstImaginal) {
                            nRange = [testPath rangeOfString:path];
                            if (nRange.location != NSNotFound)  {
                                // We got the First Imaginal File
                                bIsFirstImaginal = bHaveFirstImaginal = TRUE;
                                pathToPlay = testPath;
                                nCurrentFile_ = iCnt+1;           // Remember where we start at (and make it a 1-based index)
                                
                                // Now find out how long this file is (in seconds)   
                                NSURL *url = [NSURL fileURLWithPath:pathToPlay];
                                AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                                self.totalPlaybackDuration += CMTimeGetSeconds(audioAsset.duration);   // Add the length of this file
                                self.totalPlaybackDuration -= originalStartOffset_;                    // Subtract the Start Offset
                            }
                        }    
                        
                        // Look for the last imaginal file?
                        if ((nCurrentFile_ != 0) && !bHaveLastImaginal) {
                            nRange = [testPath rangeOfString:pathLast];
                            if (nRange.location != NSNotFound)  {
                                // We got the Last Imaginal File  
                                bIsLastImaginal = bHaveLastImaginal = TRUE;
                                if (bIsFirstImaginal) {
                                    // If it also was the first, then the duration is simply the EndOffset - StartOffset
                                    self.totalPlaybackDuration = (originalEndOffset_ - originalStartOffset_);
                                } else {
                                    // We have the last imaginal file...and this is interesting
                                    // ...we really don't care how long it is!  We just need the endOffset (which we already have)
                                    // But for completeness (and possible future verification), I am grabbing the length
                                    // ...the length must be >= offset (since the offset is the first part of the audio file)
                                    //NSURL *url = [NSURL fileURLWithPath:testPath];
                                    //AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                                    
                                    self.totalPlaybackDuration += originalEndOffset_;
                                }
                            } else {
                                // OK, so this is not the last Imaginal
                                // If it also was not the first one, then we will add its time to our duration
                                if (!bIsFirstImaginal) {
                                    // Add the duration of this file
                                    NSURL *url = [NSURL fileURLWithPath:testPath];
                                    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                                    self.totalPlaybackDuration += CMTimeGetSeconds(audioAsset.duration);   // Add the length of this file
                                }
                            }
                        }
                        
                        // Done with this iteration...we don't know what the next files are yet!
                        bIsFirstImaginal = bIsLastImaginal = FALSE;
                    }
                    
                }
                
            }  
            else {
                //NSLog(@"We only have 1 file");
                nCurrentFile_ = 1;
                
                // Do we want to pick an imaginal file?
                if (bPickImaginalFile == FALSE)
                {
                    // Not using an imaginal file, so...
                    // Check to see if they were listening before...if so, start them where they left off
                    AuxSessionInfo *auxInfo = [AuxSessionInfo alloc];
                    auxInfo.pListFileName = [[NSString alloc] initWithFormat:@"AuxSessionInfo %@",self.sessionRank];
                    //NSLog(@"checking to see if we can restart...fn: %@",auxInfo.pListFileName);
                    BOOL bAuxFileExists_ = [auxInfo initPlist];
                    
                    // Only continue if we have an auxiliary file
                    if (bAuxFileExists_) {
                        //NSLog(@"auxiliary file found...continue possible restart...");
                        // ...and only if the current file exists
                        if (auxInfo.currentFileName != nil) {
                            //NSLog(@"..RESTARTING where we left off! ===============");
                            pathToPlay = auxInfo.currentFileName;
                            self.restartOffset = [auxInfo.currentOffset doubleValue];   // Offset into the file..when we find it
                            self.restartSliderOffset = self.restartOffset;          // Slider offset to track total recording listened to
                            
                            //NSLog(@"Restart for Session #: %@ at position: %f",self.sessionRank,self.restartSliderOffset);
                            
                        }
                        else {
                            NSLog(@"Whoops...no file..cannot restart");
                        }
                    } else {
                        NSLog(@"Restart info does not exist...cannot restart");
                    }
                }
                
                
            }
            
            [fileManager release];
            
        }
    }
    
    
    
    if (self.audioPlayer != nil) {
        [self.audioPlayer stop];
    }
    
    // Current file to play
    self.audioFilePathCurrent = pathToPlay;
    
    // Hide the File size label...only show it if the file exists
    //  audioFileLabel_.hidden = YES;
    
    if (self.audioFilePathCurrent != nil) {
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.audioFilePathCurrent] error:nil];
        player.delegate = self;
        
        self.audioPlayer = player;
        [player release];
        
        [self.audioPlayer prepareToPlay];
        
        
        /*
         // Determine and display the size of this file
         NSError *attributesError=nil;
         NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&attributesError];
         
         NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
         long long fileSize = [fileSizeNumber longLongValue];
         if (fileSize < 1000000) {
         [audioFileLabel_ setText:[NSString stringWithFormat:@"(File Size: %lld KB)", fileSize/1000]];
         } else {          
         [audioFileLabel_ setText:[NSString stringWithFormat:@"(File Size: %lld MB)", fileSize/1000000]];
         }
         audioFileLabel_.hidden = NO;
         */
        
        if (startOffset > 0 && startOffset < endOffset && endOffset < self.audioPlayer.duration) {
            // Valid start and end offsets.
            self.playbackOffset = startOffset;
            self.playbackDuration = endOffset - startOffset;
        } else if (startOffset > 0 && startOffset < self.audioPlayer.duration) {
            // Valid start offset, invalid or missing end offset.
            self.playbackOffset = startOffset;
            self.playbackDuration = self.audioPlayer.duration - startOffset;
        } else if (endOffset > 0 && endOffset < self.audioPlayer.duration) {
            // Valid end offset, invalid or missing start offset.
            self.playbackOffset = 0;
            self.playbackDuration = self.audioPlayer.duration - endOffset;
        } else {
            // Invalid or missing offsets.
            self.playbackOffset = 0;
            self.playbackDuration = self.audioPlayer.duration;
        }
        
        
        // Do this differently for Imaginal files...we need the total duration of all files that are imaginal
        if (nTotalFiles_ > 1)
        {
            self.playbackDuration = self.totalPlaybackDuration;
            
            // If this is not the first imaginal file, remove the start offset
            if (self.audioFilePathLast != nil) {          // != nil means we are working with imaginal files
                if (self.audioFilePathFirst != nil) {     // Sanity check...should always be non nil
                    NSRange nRange = [self.audioFilePathCurrent rangeOfString:self.audioFilePathFirst];
                    if (nRange.location == NSNotFound)  {
                        // This is not the first imaginal file, don't use a starting offset
                        self.playbackOffset = 0;
                    }
                }
                
            }
            
            // And if this is the last imaginal file...set the end offset
            if ((self.audioFilePathCurrent != nil) && (self.audioFilePathLast != nil)) {
                NSRange nRange = [self.audioFilePathCurrent rangeOfString:self.audioFilePathLast];
                if (nRange.location != NSNotFound)  {
                    // But only set this if it is not also the first imaginal file
                    if (self.playbackOffset == 0)
                        self.playbackDuration = self.originalEndOffset;
                }
            }
        }
        
        self.audioPlayer.currentTime = self.playbackOffset;
        self.controlButton.hidden = NO;
        self.infoLabel.hidden = YES;
        
    } else {
        self.playbackOffset = 0.0;
        self.playbackDuration = 0.0;
        self.controlButton.hidden = YES;
        self.infoLabel.hidden = NO;
    }
    
    
    if ((self.totalPlaybackDuration > 0) && (self.playbackSlider.value > 0)) {
        // We have multiple files in progress, don't reset these values!
    }
    else {
        [self.playbackSlider setMinimumValue:self.playbackOffset];
        [self.playbackSlider setMaximumValue:self.playbackOffset + self.playbackDuration];
        [self.playbackSlider setValue:self.playbackOffset];
    }
    
    // And if we are restarting...set those values where needed
    if (self.restartOffset != 0.0) {
        [self.playbackSlider setValue:self.restartSliderOffset];      // Set the slider so the user sees where they are at
        self.audioPlayer.currentTime = self.restartOffset;      // And set the player so that we actually start here!
    }
    
    
    [self updateTimestamps];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
}

/**
 *  timerDidFire
 */
- (void)timerDidFire:(NSTimer *)timer {
    if (self.audioPlayer.currentTime >= (self.playbackOffset + self.playbackDuration)) {
        [self stopAudioPlayback];
        
        // Stop the timer!
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self updateTimestamps];
}

/**
 *  updateTimestamps
 */
- (void)updateTimestamps {
    self.playbackSlider.value = self.audioPlayer.currentTime + self.previousDurations;
    
    // ** This is not 100% correct. There are corner cases here when the timestamps are not displayed properly. **
    
    // Normalize the visible timestamps to be set to 0 regardless of the any offsets. We
    // also round the time values since most of the offsets will be fractional floats.
    NSTimeInterval normalizedTime = ceil(MAX(0, self.previousDurations + self.audioPlayer.currentTime - self.playbackOffset));
    NSTimeInterval duration = ceil(MAX(normalizedTime, self.playbackDuration));
    
    NSInteger elapsedMinutes = normalizedTime / 60;
    NSInteger elapsedSeconds = normalizedTime - (elapsedMinutes * 60);
    self.elapsedLabel.text = [NSString stringWithFormat:@"%02i:%02i", elapsedMinutes, elapsedSeconds];
    
    NSInteger remainingMinutes = round(duration - normalizedTime) / 60;
    NSInteger remainingSeconds = round(duration - normalizedTime) - (remainingMinutes * 60);
    self.remainingLabel.text = [NSString stringWithFormat:@"-%02i:%02i", remainingMinutes, remainingSeconds];
}

@end
