//
//  TextVideoActionViewController.m
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
#import "Asset.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TextVideoActionViewController.h"
#import "TextVideoAction.h"
#import "PECoachConstants.h"
#import "Librarian.h"
#import "UIView+Positionable.h"
#import "ViewBCVideoController.h"
#import "PECoachAppDelegate.h"
#import "Session.h"
#import <QuartzCore/QuartzCore.h>
#import "MobileCoreServices/MobileCoreServices.h"


#define kSegmentedControlIndexVideo 0
#define kSegmentedControlIndexText 1

@implementation TextVideoActionViewController

#pragma mark - Properties

@synthesize videoButton = videoButton_;
@synthesize textView = textView_;
@synthesize urlLabel = urlLabel_;
@synthesize urlButton = urlButton_;

#pragma mark - Lifecycle

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // These views don't use the normal green background...
  self.view.backgroundColor = self.defaultSolidViewBackgroundColor;
  
  // Dummy check...
  if ([self.action isKindOfClass:[TextVideoAction class]]) {
    TextVideoAction *textVideoAction = (TextVideoAction *)self.action;
      
     
    // Create a textView if this action has text to display.
    if (textVideoAction.text != nil) {
      CGRect textViewFrame = CGRectMake(0, self.infoView.frame.origin.y + self.infoView.frame.size.height, 
                                        self.view.frame.size.width, self.view.frame.size.height - self.infoView.frame.size.height);
      textViewFrame = CGRectInset(textViewFrame, kUIViewVerticalInset, kUIViewHorizontalInset);
      UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
      textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      textView.alwaysBounceVertical = YES;
      textView.backgroundColor = [UIColor clearColor];
      textView.editable = NO;
        textView.font = [UIFont systemFontOfSize:16.0];  // 06/27/2012 make this font a little bigger self.defaultTextFont;
      textView.text = textVideoAction.text;
      //textView.textColor = self.defaultTextColor;
        textView.textColor = [UIColor whiteColor];
      [self.view addSubview:textView];
      self.textView = textView;
      [textView release];
    }
      
      
 
    
    // Create a button for launching the video if there's a video path.
    if (textVideoAction.videoPath != nil) {
      UIButton *videoButton = [self buttonWithTitle:NSLocalizedString(@"Play Video", nil)];
      [videoButton addTarget:self action:@selector(handleVideoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
      // Note that the roundf call is to make sure the origin isn't straddling a pixel, which
      // causes the buttons title text to be blurry. 
      CGRect buttonFrame = videoButton.frame;
      buttonFrame.origin.x = roundf((self.view.frame.size.width - buttonFrame.size.width) / 2);
      buttonFrame.origin.y = roundf((self.view.frame.size.height - buttonFrame.size.height) / 2);
      videoButton.frame = buttonFrame;

      [self.view addSubview:videoButton];
      self.videoButton = videoButton;
        
        // Provide the URL for the video        
        UILabel *urlLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        urlLabel.backgroundColor = [UIColor lightGrayColor];
        urlLabel.font = [UIFont systemFontOfSize:14.0];
        urlLabel.layer.cornerRadius = 4.0;
        urlLabel.numberOfLines = 5;
        urlLabel.textAlignment = UITextAlignmentCenter;
        urlLabel.text = NSLocalizedString(@"Trouble viewing the videos?\nWatch the videos in any browser!\n\nTap the 'URL' button to send\nan email with the video URLs.",nil);
        urlLabel.textColor = [UIColor blackColor];
        [urlLabel sizeToFit];
        
        [self.view addSubview:urlLabel];
        self.urlLabel = urlLabel;
        [urlLabel release];
        
        [self.urlLabel positionBelowView:self.videoButton margin:kUIViewVerticalMargin*2];
        //[self.urlLabel centerHorizontallyInView:self.view];
        
        UIButton *urlButton = [self buttonWithTitle:NSLocalizedString(@"URL", nil)];
        [urlButton addTarget:self action:@selector(handleUrlButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        // Note that the roundf call is to make sure the origin isn't straddling a pixel, which
        // causes the buttons title text to be blurry. 
        //CGRect urlFrame = urlButton.frame;
        //urlFrame.origin.x = roundf((self.view.frame.size.width - urlFrame.size.width) / 2);
        //urlFrame.origin.y = roundf((self.view.frame.size.height - urlFrame.size.height) / 2);
        //urlButton.frame = urlFrame;
        
        [self.view addSubview:urlButton];
        self.urlButton = urlButton;
        
        [self.urlButton positionBelowView:self.videoButton margin:kUIViewVerticalMargin*6];
        [self.urlButton positionToTheRightOfView:self.urlLabel margin:kUIViewVerticalMargin];
    }
    
    // If this action has both a text component and a video component, then add a 
    // segmented control at the top to toggle between the two. 
    if (textVideoAction.videoPath != nil && textVideoAction.text != nil) {
      NSArray *segmentItems = [NSArray arrayWithObjects:NSLocalizedString(@"Video", nil), NSLocalizedString(@"Text", nil), nil];
      UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentItems];

      segmentedControl.frame = CGRectZero;
      segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
      segmentedControl.selectedSegmentIndex = kSegmentedControlIndexVideo;
      [segmentedControl sizeToFit];
      
      // Center the segmented control just below the info view.
      CGRect segmentedControlFrame = CGRectMake(0, 0, 180, segmentedControl.frame.size.height);
      segmentedControlFrame.origin.x = (self.view.frame.size.width - segmentedControlFrame.size.width) / 2;
      segmentedControlFrame.origin.y = self.infoView.frame.origin.y + self.infoView.frame.size.height + kUIViewVerticalInset;
      segmentedControl.frame = segmentedControlFrame;
      
      [segmentedControl addTarget:self action:@selector(handleSegmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
      [self.view addSubview:segmentedControl];
      [segmentedControl release];
      
      // Need to resize text view. 
      CGRect textViewFrame = self.textView.frame;
      textViewFrame.origin.y = segmentedControlFrame.origin.y + segmentedControlFrame.size.height + kUIViewVerticalMargin;
      textViewFrame.size.height = textViewFrame.size.height - (segmentedControlFrame.origin.y + kUIViewVerticalMargin);
      self.textView.frame = textViewFrame;
      
      self.textView.hidden = YES;
      self.videoButton.hidden = NO;
    }

  }
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.videoButton = nil;
  self.textView = nil;
  
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"TEXT VIDEO ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [videoButton_ release];
  [textView_ release];
  
  [super dealloc];
}

#pragma mark - UI Actions

/**
 *  handleVideoButtonTapped
 */
- (void)handleVideoButtonTapped:(id)sender {
    
    // Are we recording right now?  If so, we can't watch a video...
    if (self.session.audioRecorder != Nil) {
        if (self.session.audioRecorder.isRecording == YES) {
            
            // Let the user know this action will stop the recording
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Recording in Progress",nil)
                                  message:NSLocalizedString(@"The video cannot be watch while the recording is in progress.",nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            return;             // And we are out of here!
        }
    }

    TextVideoAction *textVideoAction = (TextVideoAction *)self.action;

    // We are going to watch a video...denote this so that we don't interupt our Visit timer 
    PECoachAppDelegate *appDelegate = (PECoachAppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.watchingVideo = YES;
   
    NSString *controllerBundle;
    controllerBundle = @"ViewBCVideoController";
    
    ViewBCVideoController *anotherController2 = [[ViewBCVideoController alloc] initWithNibName:controllerBundle bundle:nil];
    anotherController2.title = self.infoLabel.text;
    long long videoID = [[appDelegate getAppSetting:@"Brightcove" withKey:textVideoAction.videoPath] longLongValue];
    anotherController2.videoDescription = self.infoLabel.text;
    anotherController2.videoID = videoID;
    anotherController2.delegate = self;
    [self.navigationController pushViewController:anotherController2 animated:YES];
    //[anotherController2 release];
    

}

/**
 *  handleUrlButtonTapped
 */
- (void)handleUrlButtonTapped:(id)sender {
    
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			//[self launchMailAppOnDevice];  // This will launch the Email app...don't do it for now
            // Didn't work...probably email is not available on this device
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Email Error",nil)
                                  message:NSLocalizedString(@"Email cannot be sent from this device.  Please setup Email or check your Email configuration.",nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
		}
	}


}

/**
 *  handleSegmentedControlTapped
 */
- (void)handleSegmentedControlTapped:(id)sender {
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == kSegmentedControlIndexVideo) {
        [Analytics logEvent:@"VIDEO FORMAT CHOSEN"];
        self.textView.hidden = YES;
        self.videoButton.hidden = NO;
        self.urlLabel.hidden = NO;
        self.urlButton.hidden = NO;
    } else {
        [Analytics logEvent:@"TEXT FORMAT CHOSEN"];
        self.textView.hidden = NO;
        self.videoButton.hidden = YES;
        self.urlLabel.hidden = YES;
        self.urlButton.hidden = YES;
  }
}
#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface to send the video URLs to the email address chosen by the user 
-(void)displayComposerSheet 
{
    // We are here because the user wants an alternative way of seeing the videos (they are too slow, etc)
    // We will create an email that will contain the URLs of each video (along with titles)
    // This way they can view the videos through any web browser on the platform of their choosing
    
    // We will use essentially the same XML data that the App uses to identify these videos
    // However, the XML data is not structured in a friendly way for extracting what we need
    // And if we re-architext the data structure, we will create redundancy/complexity in that file
    // So rather than re-architect the data structure, we are going to 'cherry' pick the assets that we need
    // So without further explanation, or any apology, here we go
    // Note:  All of the elements identified below are 'assets'
    
    // Identify the 3 video groups
    NSArray *videoGroupNames = [NSArray arrayWithObjects:@"kVideoGroupTitleCommonReactionsToTrauma", 
                                @"kVideoGroupTitleBreathingRetraining", 
                                @"kVideoGroupTitlePETherapyExplained", nil];
    
    // Identify the Titles/URLs that are in each group
    // Group 0: Titles
    NSArray *videoGroupTitles0 = [NSArray arrayWithObjects:@"kTraumaReactionsViewAllTitle",  
                                    @"kTraumaReactionsFearAndAnxietyTitle", 
                                    @"kTraumaReactionsAvoidanceTitle", 
                                    @"kTraumaReactionsArousalTitle", 
                                    @"kTraumaReactionsAngerTitle", 
                                    @"kTraumaReactionsDepressionTitle", 
                                    @"kTraumaReactionsThoughtsTitle", 
                                    @"kTraumaReactionsAlcoholTitle", 
                                    @"kTraumaReactionsConclusionTitle", nil];
    
    // Group 0: URLs
    NSArray *videoGroupURLs0 = [NSArray arrayWithObjects:@"kTraumaReactionsViewAllURL",  
                                  @"kTraumaReactionsFearAndAnxietyURL", 
                                  @"kTraumaReactionsAvoidanceURL", 
                                  @"kTraumaReactionsArousalURL", 
                                  @"kTraumaReactionsAngerURL", 
                                  @"kTraumaReactionsDepressionURL", 
                                  @"kTraumaReactionsThoughtsURL", 
                                  @"kTraumaReactionsAlcoholURL", 
                                  @"kTraumaReactionsConclusionURL", nil];
    
    // Group 1: Titles
    NSArray *videoGroupTitles1 = [NSArray arrayWithObjects:@"kLearnBreathingRetrainingTitle",  
                                  @"kWatchBreathingRetrainingTitle",  nil];
    
    // Group 1: URLs
    NSArray *videoGroupURLs1 = [NSArray arrayWithObjects:@"kLearnBreathingRetrainingURL",  
                                @"kWatchBreathingRetrainingURL",  nil];
    
    // Group 2: Titles
    NSArray *videoGroupTitles2 = [NSArray arrayWithObjects:@"kPETherapyExplanationTitle",    nil];
    
    // Group 2: URLs
    NSArray *videoGroupURLs2 = [NSArray arrayWithObjects:@"kPETherapyExplanationURL",   nil];
    
    // Ok, now let's start creating the email
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    // Make sure we got it...
    if (picker == nil) {
        // Didn't work...probably email is not available on this device
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Email Error",nil)
                              message:NSLocalizedString(@"Email cannot be sent from this device.  Please setup Email or check your Email configuration.",nil)
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        // And get out of here
        return;
    }
	picker.mailComposeDelegate = self;
    
    
	[picker setSubject:NSLocalizedString(@"PE Coach Video Links",nil)];
	
    // Keep this around to make it easier if we decide we want to pre-designate receipients
	// Set up recipients
	//NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
	//NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
	//NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
	
	//[picker setToRecipients:toRecipients];
	//[picker setCcRecipients:ccRecipients];	
	//[picker setBccRecipients:bccRecipients];
	
	// Create the body of the message (usig HTML)
    // The language specific stuff will be localized so it can be maintained outside of this code (MVC)
    // The HTML will be left as static text here
    NSMutableString *emailBody = [NSMutableString stringWithCapacity:1500];

    // Start out with some HTML header information with an introductory message
    [emailBody appendString:@"<html><body style=""background-color:blue;""><p style=""font-family:arial;color:red;font-size:14px;"">"];
    [emailBody appendString:NSLocalizedString(@"PE Coach Video Links",nil)];
    [emailBody appendString:@"</p><p style=""font-family:arial;color:blue;font-size:14px;"">"];
    [emailBody appendString:NSLocalizedString(@"The following table contains the links (URLs) for the videos in PE Coach.  You can click on the Titles in the table.  Or you can cut-n-paste the URLs to your favorite browser.",nil)];
    [emailBody appendString:@"</p>"];
    
    // Now loop through the Group Names and build a table with Titles/URLs for each video in that group
    NSInteger groupIndex = 0;
    for (id groupName in videoGroupNames)
    {
        // Start a new table
        [emailBody appendString:@"<table border=""4"" width=""300"" rules=groups style=""background-color:#BBEBFF;""><thead><tr><th colspan=""2"" align=""center"">"];
        [emailBody appendString:[[self.librarian assetForKey:groupName] content]];
        [emailBody appendString:@"</th><tr><th align=""left"">Video Title</th><th>URL</th></tr></thead>"];
        
        // Figure out how big the current group of videos is
        NSInteger count = 0;
        switch (groupIndex) {
            case 0:
                // Video Group 0
                count = [videoGroupTitles0 count];
                break;
            case 1:
                // Video Group 1
                count = [videoGroupTitles1 count];
                break;
            case 2:
                // Video Group 2
                count = [videoGroupTitles2 count];
                break;
                
            default:
                break;
        }
        
        // Now build each Title/URL in this group
        for (int i=0; i<count; i++){
            
            // Build a row...
            // Hyperlinked Title
            [emailBody appendString:@"<tbody><tr bgcolor=""#FFDD75""><td colspan=""2"" align=""left"" style=""font-family:arial;color:black;font-size:10px;"">"];
            [emailBody appendString:@"<a href="""];
            
            // Here's the url           // Grab the Title/URL based on which Group we are on
            switch (groupIndex) {
                case 0:
                    // Video Group 0
                    [emailBody appendString:[[self.librarian assetForKey:[videoGroupURLs0 objectAtIndex:i]] content]];
                    break;
                case 1:
                    // Video Group 1
                    [emailBody appendString:[[self.librarian assetForKey:[videoGroupURLs1 objectAtIndex:i]] content]];
                    break;
                case 2:
                    // Video Group 2
                    [emailBody appendString:[[self.librarian assetForKey:[videoGroupURLs2 objectAtIndex:i]] content]];
                    break;
                    
                default:
                    break;
            }
            
            // ...close the url portion
            [emailBody appendString:@""">"];
            // Here's the title            Grab the Title/URL based on which Group we are on
            switch (groupIndex) {
                case 0:
                    // Video Group 0
                    [emailBody appendString:[[self.librarian assetForKey:[videoGroupTitles0 objectAtIndex:i]] content]];
                    break;
                case 1:
                    // Video Group 1
                    [emailBody appendString:[[self.librarian assetForKey:[videoGroupTitles1 objectAtIndex:i]] content]];
                    break;
                case 2:
                    // Video Group 2
                    [emailBody appendString:[[self.librarian assetForKey:[videoGroupTitles2 objectAtIndex:i]] content]];
                    break;
                    
                default:
                    break;
            }
            [emailBody appendString:@"</a>"];
            [emailBody appendString:@"</td><tr bgcolor=""#FFDD75"">"];
            // Just the link (so they can cut an paste)
            [emailBody appendString:@"<td  colspan=""2"" align=""right"" style=""font-family:arial;color:black;font-size:10px;"">"];            
           
            // Here's the url           // Grab the Title/URL based on which Group we are on
            switch (groupIndex) {
                case 0:
                    // Video Group 0
                    [emailBody appendString:[[self.librarian assetForKey:[videoGroupURLs0 objectAtIndex:i]] content]];
                    break;
                case 1:
                    // Video Group 1
                    [emailBody appendString:[[self.librarian assetForKey:[videoGroupURLs1 objectAtIndex:i]] content]];
                    break;
                case 2:
                    // Video Group 2
                    [emailBody appendString:[[self.librarian assetForKey:[videoGroupURLs2 objectAtIndex:i]] content]];
                    break;
                    
                default:
                    break;
            }
            [emailBody appendString:@"</td></tr></tbody>"];    
        }
        
        // Finish off the table
        [emailBody appendString:@"</table>"];    
        
        // Indicate we have gone on to the next group
        groupIndex++;
    }
    
    // Finish off the html
    [emailBody appendString:@"</body></html>"]; 

    // Present this to the user for their own edits (email addresses, etc)  
	[picker setMessageBody:emailBody isHTML:YES];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			//message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			//message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			//message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			//message.text = @"Result: failed";
			break;
		default:
			//message.text = @"Result: not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark View BC delegate
- (void)dismissViewBC:(ViewBCVideoController *)controller {
    // The video finished...return to menu
    [controller showWaitingOnDownload:NO];
	[controller dismissModalViewControllerAnimated:YES];
    
    // Where do we go from here...let's reselect this tab bar item
    self.tabBarController.selectedIndex = 3;
}


@end
