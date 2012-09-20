//
//  ImaginalExposureActionViewController.m
//  PECoach
//

#include <QuartzCore/QuartzCore.h>
#import "ImaginalExposureActionViewController.h"
#import "AudioControlView.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "Recording.h"
#import "Scorecard.h"
#import "Session.h"
#import "UIView+Positionable.h"
#import "Analytics.h"
#import "AuxSessionInfo.h"

@implementation ImaginalExposureActionViewController

#pragma mark - Properties

@synthesize instructionsLabel = instructionsLabel_;
@synthesize ratingsView = ratingsView_;
@synthesize preSUDSLabel = preSUDSLabel_;
@synthesize postSUDSLabel = postSUDSLabel_;
@synthesize peakSUDSLabel = peakSUDSLabel_;
@synthesize preSUDSTextField = preSUDSTextField_;
@synthesize postSUDSTextField = postSUDSTextField_;
@synthesize peakSUDSTextField = peakSUDSTextField_;
@synthesize audioControlView = audioControlView_;
@synthesize state = state_;
@synthesize audioHackTimer = audioHackTimer_;
@synthesize imaginalFilePathStart = imaginalFilePathStart_;
@synthesize imaginalFilePathEnd = imaginalFilePathEnd_;
@synthesize bImaginalFileExists = bImaginalFileExists_;

#pragma mark - Lifecycle

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.defaultSolidViewBackgroundColor;
    
    // Retrieve the name and attributes of the imaginal recording file
    AuxSessionInfo *auxInfo = [AuxSessionInfo alloc];
    auxInfo.pListFileName = [[NSString alloc] initWithFormat:@"AuxSessionInfo %@",self.session.rank];
    bImaginalFileExists_ = [auxInfo initPlist];
    
    // Only do this if the imaginal audio recording exists  
    if (bImaginalFileExists_)
    {
        // But it only exists if an imaginal file has been specified
        if (auxInfo.imaginalFileNameStart != nil) {
            CGFloat contentWidth = self.formScrollView.frame.size.width - (kUIViewHorizontalInset * 2);
            CGRect instructionsLabelFrame = CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, contentWidth, self.defaultTextFont.lineHeight * 2);
            UILabel *instructionsLabel = [self formLabelWithFrame:instructionsLabelFrame text:nil];
            instructionsLabel.font = self.defaultTextFont;
            instructionsLabel.numberOfLines = 2;
            instructionsLabel.textColor = [UIColor whiteColor];
            
            [self.formScrollView addSubview:instructionsLabel];
            self.instructionsLabel = instructionsLabel;
            
            // Add a wrapper UIView to the SUDS fields so that they can have a border.
            UIView *borderedView = [[UIView alloc] initWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, contentWidth, 0)];
            borderedView.layer.borderColor = self.defaultBorderColor.CGColor;
            borderedView.layer.borderWidth = 1.0;
            
            __block UIView *lastView = nil;
            NSArray *titles = [NSArray arrayWithObjects:NSLocalizedString(@"Pre - SUDS", nil),
                               NSLocalizedString(@"Post - SUDS", nil), 
                               NSLocalizedString(@"Peak - SUDS", nil), nil];
            
            [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
                CGFloat SUDSLabelWidth = 100.0;
                CGFloat textFieldWidth = 80.0;
                
                CGRect labelFrame = CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalMargin, SUDSLabelWidth, kUITextFieldDefaultHeight);
                UILabel *label = [self formLabelWithFrame:labelFrame text:obj];
                label.textColor = [UIColor whiteColor];
                [borderedView addSubview:label];
                
                CGRect textFieldFrame = CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalMargin, textFieldWidth, kUITextFieldDefaultHeight);
                UITextField *textField = [self SUDSTextFieldWithFrame:textFieldFrame text:nil];
                [textField positionToTheRightOfView:label margin:kUIViewHorizontalMargin];
                [borderedView addSubview:textField];
                
                if (lastView != nil) {
                    [label positionBelowView:lastView margin:kUIViewVerticalMargin];
                    [textField alignTopWithView:label];
                }
                
                lastView = [label retain];
                
                if (index == 0) {
                    self.preSUDSLabel = label;
                    self.preSUDSTextField = textField;
                } else if (index == 1) {
                    self.postSUDSLabel = label;
                    self.postSUDSTextField = textField;
                } else if (index == 2) {
                    self.peakSUDSLabel = label;
                    self.peakSUDSTextField = textField;
                }
            }];
            
            [lastView release];
            
            [borderedView positionBelowView:self.instructionsLabel margin:kUIViewVerticalMargin];
            [borderedView resizeHeightToContainSubviewsWithMargin:kUIViewVerticalMargin];
            
            [self.formScrollView addSubview:borderedView];
            self.ratingsView = borderedView;
            [borderedView release];
            
            
            CGRect audioViewFrame = CGRectMake(0, 0, borderedView.frame.size.width, 0);
            AudioControlView *audioControlView = [[AudioControlView alloc] initWithFrame:audioViewFrame 
                                                                                filePath:imaginalFilePathStart_];
            [audioControlView resizeHeightToContainSubviewsWithMargin:0.0];
            
            [audioControlView alignLeftWithView:borderedView];
            [audioControlView positionBelowView:borderedView margin:kUIViewVerticalMargin];
            
            [self.formScrollView addSubview:audioControlView];
            self.audioControlView = audioControlView;
            [audioControlView release];
            
            // Always allow more sessions!
            //if ([self.session.recording.scorecards count] == 0) {
            self.state = kImaginalExposureActionViewStateEnterPreSUDS;
            /*
             } else {
             Scorecard *scorecard = [self.session.recording.scorecards anyObject];
             self.preSUDSTextField.text = [scorecard.preSUDSRating stringValue];
             self.postSUDSTextField.text = [scorecard.postSUDSRating stringValue];
             self.peakSUDSTextField.text = [scorecard.peakSUDSRating stringValue];
             self.state = kImaginalExposureActionViewStateEnterCompleted;
             }
             */
        }
    }
    else {
        // The imaginal file does not exist...let the user know that   
        UIFont    *myFont = [UIFont boldSystemFontOfSize:14.0];
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, 200, myFont.lineHeight)];
        [myLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [myLabel setBackgroundColor:[UIColor clearColor]];
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setFont:myFont];
        [myLabel setText:NSLocalizedString(@"Audio recording not found.", nil)];
        [myLabel setTextAlignment:UITextAlignmentCenter];
        
        [myLabel centerHorizontallyInView:self.view];
        [self.view addSubview:myLabel];
        [myLabel release];
    }
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
    self.instructionsLabel = nil;
    self.ratingsView = nil;
    self.preSUDSLabel = nil;
    self.postSUDSLabel = nil;
    self.peakSUDSLabel = nil;
    self.preSUDSTextField = nil;
    self.postSUDSTextField = nil;
    self.peakSUDSTextField = nil;
    self.audioControlView = nil;
    self.imaginalFilePathStart = nil;
    self.imaginalFilePathEnd = nil;
    
    [self.audioHackTimer invalidate];
    self.audioHackTimer = nil;
    
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
    
    // Retrieve the name and attributes of the imaginal recording file
    AuxSessionInfo *auxInfo = [AuxSessionInfo alloc];
    auxInfo.pListFileName = [[NSString alloc] initWithFormat:@"AuxSessionInfo %@",self.session.rank];
    bImaginalFileExists_ = [auxInfo initPlist];
    
    // Only continue if we have an imaginal file
    if (bImaginalFileExists_) {
        // But it only exists if an imaginal file has been specified
        if (auxInfo.imaginalFileNameStart != nil) {
            imaginalFilePathStart_ = [[NSString alloc] initWithString:auxInfo.imaginalFileNameStart];
            imaginalFilePathEnd_ = [[NSString alloc] initWithString:auxInfo.imaginalFileNameEnd];
            
            
            // Tell the Audio player to look for all of our files (and to start with our imaginal file
            audioControlView_.nTotalFiles = -1;
            self.audioControlView.sessionRank = self.session.rank;
            //NSLog(@"ImaginalExposureActionViewController.viewWillAppear is calling loadAudioFileAtPath");        
            [self.audioControlView loadAudioFileAtPath:imaginalFilePathStart_
                                           startOffset:[auxInfo.imaginalExposureStartsOffset doubleValue]
                                             endOffset:[auxInfo.imaginalExposureEndsOffset doubleValue]
                                  lastImaginalFilePath:imaginalFilePathEnd_];
            
            
            self.audioHackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                                                   target:self 
                                                                 selector:@selector(audioHackTimerDidFire:) 
                                                                 userInfo:nil 
                                                                  repeats:YES];
        }
        
    }
    [auxInfo release];
}

/**
 *  viewWillDisappear
 */
- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"ImaginalExposureActionViewController.viewWillDisappear: call stopAudioPlayback");
    [self.audioControlView stopAudioPlayback];
    [self.audioHackTimer invalidate];
    self.audioHackTimer = nil;
    
    [super viewWillDisappear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"IMAGINAL EXPOSURE ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
    [instructionsLabel_ release];
    [ratingsView_ release];
    [preSUDSLabel_ release];
    [postSUDSLabel_ release];
    [peakSUDSLabel_ release];
    [preSUDSTextField_ release];
    [postSUDSTextField_ release];
    [peakSUDSTextField_ release];
    [audioControlView_ release];
    [imaginalFilePathStart_ release];
    [imaginalFilePathEnd_ release];
    
    [super dealloc];
}

#pragma mark - Property Accessors

/**
 *  state
 */
- (void)setState:(ImaginalExposureActionViewState)state {
    if (state_ != state) {
        state_ = state;
        
        //NSLog(@"ImaginalExposureActionViewController.setState: call stopAudioPlayback");
        [self.audioControlView stopAudioPlayback];
        
        switch (state) {
            case kImaginalExposureActionViewStateEnterPreSUDS: {
                self.instructionsLabel.text = NSLocalizedString(@"Please enter Pre SUDS Ratings.", nil);
                [self.saveButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
                
                self.preSUDSLabel.hidden = NO;
                self.preSUDSTextField.hidden = NO;
                self.preSUDSTextField.enabled = YES;
                
                self.postSUDSLabel.hidden = YES;
                self.postSUDSTextField.hidden = YES;
                
                self.peakSUDSLabel.hidden = YES;
                self.peakSUDSTextField.hidden = YES;
                
                self.audioControlView.hidden = YES;
                self.saveButton.enabled = [self.preSUDSTextField.text length] > 0;
                break;
            }
                
            case kImaginalExposureActionViewStatePlayRecording: {
                self.instructionsLabel.text = NSLocalizedString(@"Please listen to the entire audio clip. \
                                                                Click 'Next' button after you are done.", nil);
                [self.saveButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
                
                self.preSUDSLabel.hidden = NO;
                self.preSUDSTextField.hidden = NO;
                self.preSUDSTextField.enabled = NO;
                
                self.postSUDSLabel.hidden = YES;
                self.postSUDSTextField.hidden = YES;
                
                self.peakSUDSLabel.hidden = YES;
                self.peakSUDSTextField.hidden = YES;
                
                self.audioControlView.hidden = NO;
                self.saveButton.enabled = NO;
                break;
            }
                
            case kImaginalExposureActionViewStateEnterPostSUDS: {
                self.instructionsLabel.text = NSLocalizedString(@"Please enter Post SUDS and Peak SUDS Ratings below.", nil);
                [self.saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
                
                self.preSUDSLabel.hidden = NO;
                self.preSUDSTextField.hidden = NO;
                self.preSUDSTextField.enabled = NO;
                
                self.postSUDSLabel.hidden = NO;
                self.postSUDSTextField.hidden = NO;
                
                self.peakSUDSLabel.hidden = NO;
                self.peakSUDSTextField.hidden = NO;
                
                self.audioControlView.hidden = YES;
                break;
            }
                
            case kImaginalExposureActionViewStateEnterCompleted: {
                self.instructionsLabel.hidden = YES;
                [self.ratingsView alignTopWithView:self.instructionsLabel];
                
                self.preSUDSLabel.hidden = NO;
                self.preSUDSTextField.hidden = NO;
                self.preSUDSTextField.enabled = NO;
                
                self.postSUDSLabel.hidden = NO;
                self.postSUDSTextField.hidden = NO;
                self.postSUDSTextField.enabled = NO;
                
                self.peakSUDSLabel.hidden = NO;
                self.peakSUDSTextField.hidden = NO;
                self.peakSUDSTextField.enabled = NO;
                
                self.audioControlView.hidden = YES;
                
                self.saveButton.hidden = YES;
                self.saveButton.enabled = NO;
                break;
            }
                
            default: {
                // No-op
                break;
            }
        }
        
        NSArray *textFields = [NSArray arrayWithObjects:self.preSUDSTextField, self.postSUDSTextField, self.peakSUDSTextField, nil];
        [textFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UITextField *textField = (UITextField *)obj;
            textField.textColor = textField.isEnabled ? [UIColor darkTextColor] : [UIColor lightGrayColor];
        }];
        
        [self.ratingsView resizeHeightToContainSubviewsWithMargin:kUIViewVerticalMargin];
        [self.audioControlView positionBelowView:self.ratingsView margin:kUIViewVerticalMargin];
    }
}

#pragma mark - UIKeyboard Notification Methods

/**
 *  handleKeyboardWillHideNotification
 */
- (void)handleKeyboardWillHideNotification:(NSNotification*)notification {
    // We can kind of cheat here and only update the state of the Save button
    // when the keyboard is dismissed because the Save button is always hidden
    // while the keyboard is visible. 
    switch (self.state) {
        case kImaginalExposureActionViewStateEnterPreSUDS: {
            self.saveButton.enabled = [self.preSUDSTextField.text length] > 0;
            break;
        }
            
        case kImaginalExposureActionViewStatePlayRecording: {
            break;
        }
            
        case kImaginalExposureActionViewStateEnterPostSUDS: {
            self.saveButton.enabled = [self.postSUDSTextField.text length] > 0 && [self.peakSUDSTextField.text length] > 0;
            break;
        }
            
        case kImaginalExposureActionViewStateEnterCompleted:
        default: {
            // No-op
            break;
        }
    }
}

#pragma mark - Event Handlers

/**
 *  audioHackTimerDidFire
 */
- (void)audioHackTimerDidFire:(NSTimer *)time {
    if (self.state == kImaginalExposureActionViewStatePlayRecording) {
        //NSTimeInterval duration = self.audioControlView.audioPlayer.duration;
        NSTimeInterval duration = self.audioControlView.playbackOffset + self.audioControlView.playbackDuration;  
        
        // Get the current time and add the times from previous files....  
        NSTimeInterval currentTime = self.audioControlView.audioPlayer.currentTime + self.audioControlView.previousDurations;
        
        // If this is not the first file, we need to subtract the original offset 
        // (since that is also included in 'previousDuration')
        if (self.audioControlView .previousDurations > 0.0)
            currentTime -= self.audioControlView.originalStartOffset;
        
        // Enable the save button if they are within 2 seconds of the end
        // And leave it on once it is on!
        self.saveButton.enabled = self.saveButton.enabled?TRUE:(currentTime >= duration - 2.0);
    }
}

#pragma mark - Instance Methods

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
    switch (self.state) {
        case kImaginalExposureActionViewStateEnterPreSUDS: {
            self.state = kImaginalExposureActionViewStatePlayRecording;
            break;
        }
            
        case kImaginalExposureActionViewStatePlayRecording: {
            self.state = kImaginalExposureActionViewStateEnterPostSUDS;
            break;
        }
            
        case kImaginalExposureActionViewStateEnterPostSUDS: {
            if ([self.postSUDSTextField.text length] == 0 || [self.peakSUDSTextField.text length] == 0) {
                NSString *alertTitle = NSLocalizedString(@"Invalid SUDS Ratings", nil);
                NSString *alertMessage = NSLocalizedString(@"Please enter a valid SUDS for all fields.", nil);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                    message:alertMessage
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            } else {
                if (self.session.recording != nil) {
                    NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[self.preSUDSTextField.text integerValue]], @"preSUDSRating",
                                            [NSNumber numberWithInteger:[self.postSUDSTextField.text integerValue]], @"postSUDSRating",
                                            [NSNumber numberWithInteger:[self.peakSUDSTextField.text integerValue]], @"peakSUDSRating",
                                            [NSDate date], @"creationDate", nil];
                    
                    Scorecard *scorecard = [self.librarian insertNewScorecardWithValues:values];
                    scorecard.recording = self.session.recording;
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        }
        case kImaginalExposureActionViewStateEnterCompleted: {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

@end
