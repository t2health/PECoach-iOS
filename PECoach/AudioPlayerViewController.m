//
//  AudioPlayerViewController.m
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
#import "AudioPlayerViewController.h"
#import "AudioControlView.h"
#import "PECoachConstants.h"
#import "Recording.h"
#import "Session.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation AudioPlayerViewController

#pragma mark - Properties

@synthesize audioControlView = audioControlView_;

#pragma mark - Lifecycle

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect audioViewFrame = CGRectInset([self contentFrame], kUIViewHorizontalInset, kUIViewVerticalInset);
    AudioControlView *audioControlView = [[AudioControlView alloc] initWithFrame:audioViewFrame 
                                                                        filePath:self.session.recording.filePath];
    audioControlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [audioControlView resizeHeightToContainSubviewsWithMargin:0.0];
    
    [audioControlView centerVerticallyInView:self.view];
    [self.view addSubview:audioControlView];
    self.audioControlView = audioControlView;
    [audioControlView release];
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
    self.audioControlView = nil;
    
    [super viewDidUnload];
}

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Sanity check!! Because of the bizarre UI/UX in this application, it's possible
    // to get to this view controller while we're still recording. No idea what we
    // should do as the expected behavior, so for now we'll just stop recording... /shrug.
    [self stopSessionRecording];
    
    // If we were listening to recordings before, we might have old stuff
    // Reset so that we look for new recordings
    self.audioControlView.nTotalFiles = 0;   // This will prompt us to look for additional files
    self.audioControlView.sessionRank = self.session.rank;  
    
    //NSLog(@"AudioPlayerViewController.viewWillAppear is calling loadAudioFileAtPath");
    [self.audioControlView loadAudioFileAtPath:self.session.recording.filePath startOffset:0 endOffset:0 lastImaginalFilePath:nil];
}

/**
 *  viewWillDisappear
 */
- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"AudioPlayerViewController.loadNewAudioFile: call stopAudioPlayback");
    [self.audioControlView stopAudioPlayback];
    [super viewWillDisappear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"AUDIO PLAYER VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
    [audioControlView_ release];
    
    [super dealloc];
}

@end