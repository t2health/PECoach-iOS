
Brightcove iPad iPhone Kit

=======
SUMMARY
=======

The Brightcove iPad iPhone Kit is a Cocoa/Objective-C Library for playing back your Brightcove content
on iOS 3.1 and greater.

=======
INSTALL
=======

This library requires the libBrightcoveMediaAPI.a media API library to fetch videos from your account to playback. 
Please setup that library first before continuing.

(1) Create or Open an XCode project

(2) Select the Project's Target and then Get Info (click the target in the xcode pane, then command-I or File->Get Info)

(3) Choose the General tab

(4) Under the Linked Library section click the plus button

(5) A dialog will slide down, click the Add Other... button

(6) Now select the libBrightcovePlayerKit.a file distributed in the Brightcove iPad iPhone Kit zip in the lib folder

(7) Open Project Settings (Project -> Edit Project Settings)

(8) Choose the Build tab

(9) In the Search Paths section, in the Header Search Paths entry, add the directory in which you put the Brightcove iPad iPhone Kit on your computer followed by "/lib"

For Example, if you stored the Brightcove iPad iPhone Kit at /Developer/Brightcove/bc-ipad-iphone-kit-2.0.0 on your computer, then you would enter:
 
/Developer/Brightcove/bc-ipad-iphone-kit-2.0.0/lib

IMPORTANT: Ensure that the "recursive" checkbox is selected.

(10) Double-click the Other Linking Flags property in the Linking section of the Settings list.

(11) Add the following flag: 

	-ObjC
    
(12) Add the required Apple framework to your project.

In the 'Frameworks' section of your Project in XCode, ensure that MediaPlayer.framework is present:

If it is missing, right-click on the Frameworks group in XCode, select "Add" and "Existing Frameworks..." to open
a file browser that will allow you to select and add the frameworks to your project.

If you are deploying an application that is going to run on iOS 3.1 and greater change the link type from "required" to "weak".
This can be changed in the "Linked Libraries" section under your targets General tab. See step two if you don't know where this is.

(13) Close Project Settings

--------------------
OPTIONAL SHARING UIS
--------------------

If you want to include the Sharing UIs continue to step 14.

(14) Select the Project's Target and then Get Info (click the target in the xcode pane, then command-I or File->Get Info)

(15) Choose the General tab

(16) Under the Linked Library section click the plus button

(17) A dialog will slide down, click the Add Other... button

(18) Now select the libBrightcoveSharingKit.a file distributed in the Brightcove iPad iPhone Kit zip in the lib folder

(19) Still in the Linked Library section click the plus button again

(20) Select from the list presented the "libxml2.dylib" library

(21) Adding the OAuth library and header files, select the your Project (blue icon with an "A" on it) from the Groups & Files navigation.

(22) Right click select "Add" and "Existing Files..." to open a file browser

(23) Select the "OAuthConsumer" folder in the Brightcove iPad iPhone Kit zip then click "Add"

(24) Add the BCImages.bundle, Right click select "Add" and "Existing Files..." to open a file browser

(25) Select the "BCImages.bundle" file in the Brightcove iPad iPhone Kit zip

(26) Add the BCLocalizable.strings for English, Japanese and Spanish, Right click select "Add" and "Existing Files..." to open a file browser

(27) Select the "strings" folder in the Brightcove iPad iPhone Kit zip

(28) Open Project Settings (Project -> Edit Project Settings)

(29) Choose the Build tab

(30) Double-click the Other Linking Flags property in the Linking section of the Settings list.

(31) Add the following flag: 

	-all_load

=====================
IPAD IPHONE KIT USAGE
=====================

The BCMoviePlayerController class inherits from the Apple MPMoviePlayerController class. This is done to give you more control over how your video
player is displayed and exposes the increased functionality that Apple has given developers. We are moving away from the fullscreen only experience that
didn't give developers the control they need over the playback experience. The BCMoviePlayerController injects things like extracting the correct url to 
play back into the MPMoviePlayerController classes flow. The Brightcove specific methods exposed are setContentURL:(BCVideo *) video, searchForRenditionsBetweenLowBitRate:(int) 
lowBitRate andHighBitRate:(int) highBitRate and initWithContentURL:(BCVideo *) video searchForRenditionWithLowBitRate:(NSNumber *) lowBitRate 
andHighBitRate:(NSNumber *) highBitRate;. These port over the major parts of the BCPlayer class that deal with video playback. To make sure the Brightcove 
code interacts with the MPMoviePlayerController correctly you need to follow one of the following flows.
 
 Flow 1
 OS Targets: iOS 3.2 and greater 
 Description: This flow is best used when you are targeting iOS 3.2 currently only on the iPad and iOS 4 currently only on the iPhone (3G, 3GS & 4).
 Linked Library Type: Required
 
    (1) Create the object with the init method and not any other convenience methods.

        BCMoviePlayerController *player = [[BCMoviePlayerController alloc] init];
 
    (2) If you want to use the searchForRenditionsBetweenLowBitRate:andHighBitRate: method you have to call it before you set the content.

        [player searchForRenditionsBetweenLowBitRate:[NSNumber numberWithInt:200000] andHighBitRate:[NSNumber numberWithInt:300000]];
 
    (3) Finally you set the content, this can be done before or after you have added the player to a view.    

    [player setContentURL:myVideo];
 
 Flow 2
 OS Targets: iOS 3.1 and greater 
 Description: This flow allows you to develop code that will run on 3.1 and greater with out using any runtime checking to see what OS version you are running.
 Linked Library Type: Weak
 
    (1) Create the object with the initWithContentURL: searchForRenditionWithLowBitRate: andHighBitRate: method. If you do not want to change the default bit-rates
        that we search for 200000 - 500000 you can pass nil for the last two params.

        BCMoviePlayerController *player = [[BCMoviePlayerController alloc] initWithContentURL:self.video 
                                                             searchForRenditionWithLowBitRate:[NSNumber numberWithInt:200000] 
                                                                               andHighBitRate:[NSNumber numberWithInt:300000]];
 
    (2) Call the play method to start playback

        [player play];
    
 
--------------------------------------
IPAD IPHONE KIT EXAMPLE CODE 
--------------------------------------

// Don't forget to include this line in your source:
    #import "BCMoviePlayerController.h"

    BCMoviePlayerController *player = [[BCMoviePlayerController alloc] init];
    [player setContentURL:self.video]; // video fetched via the media apis, type is BCVideo
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 480.0f, 320.0f);
    UIView *pView = player.view;
    [pView setFrame:rect];
    
    [self.view addSubview:player.view];


=======
SHARING
=======
The BCSharingViewController class provides an easy way to enable your users to email links to your videos and tweet links via twitter. 
To create an view to allow the user to email a link to your video, you must first create a web accessible player for email sharing 
on http://my.brightcove.com in your account. Your application will need to know the ID of this player, since the emails will direct 
users to the sharing player.
 
During the life cycle of the BCSharingViewController there will be delegate callbacks your code will need to responde to.
 
- (UIViewController *)viewControllerToPresentEmailCompose : this is called when the sharing view needs a UIViewController to present
the in app email ui provided by Apple.
 
- (void)closeSharingView : when the sharing view is done it will call this method to let your code know it is ready to be removed from
your view.
 
- (BOOL)shouldAnimateEmailComposePresentation : this lets you customize the way the in app email is presented to your users. Returning
YES will animate the transition, returning NO will make the email view appear with out an animation.
 
- (BOOL)shouldExitApplicationToSendEmail : is optional, the sharing view defaults to using in app email. If you want to us the Mail app
on iOS you should return YES in this callback.
 
--------------------------------------
SHARING EXAMPLE CODE
--------------------------------------
 // Don't forget to include this line in your source:
    #import "BCSharingViewController.h"
 
    BCSharingViewController *bcsvc = [[BCSharingViewController alloc] init];
    [bcsvc setVideo: self.video];
    [bcsvc setSharingPlayerId: self.playerId];
    [bcsvc setDelegate:self];
    [bcsvc.view setFrame:CGRectMake(20.0f, 
                                    20.0f, 
                                    BC_SHARING_VIEW_WIDTH,
                                    BC_SHARING_VIEW_HEIGHT)];
 
    [self.view addSubview:bcsvc.view];
    
====================
APPLE HTTP STREAMING
====================
The BCMoviePlayerController will now look for HTTP Streaming renditions and Variant Playlists, http://developer.apple.com/library/ios/#technotes/tn2010/tn2224.html%23VARIANTPLAYLISTS , 
stored in the FLVURL property of the BCVideo you want to play. If no playlist file is stored in the FLVURL we look throught the renditions array 
looking for a bit-rate in the search threshold. To play your videos in this format you need to use the BCMediaDeliveryTypeHTTP_IOS media delivery 
type in your Media API calls.
