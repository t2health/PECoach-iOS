
Brightcove Media API

=======
SUMMARY
=======

The Brightcove Media API is a Cocoa/Objective-C Library for employing the JSON based Brightcove Media API 
(http://docs.brightcove.com/en/media/). The media API provides a Cocoa/Objective-C interface for the Brightcove 
video and playlist API's.

=======
INSTALL
=======

(1) Create or Open an XCode project

(2) Select the Project's Target and then Get Info (click the target in the xcode pane, then command-I or File->Get Info)

(3) Choose the General tab

(4) Under the Linked Library section click the plus button

(5) A dialog will slide down, click the Add Other... button

(6) Now select the libBrightcoveMediaAPI.a file distributed in the Brightcove Media API zip in the lib folder

(7) Open Project Settings (Project -> Edit Project Settings)

(8) Choose the Build tab

(9) In the Search Paths section, in the Header Search Paths entry, add the directory in which you put the Brightcove Media API zip on your computer followed by "/lib"

For Example, if you stored the Brightcove Media API zip at /Developer/Brightcove/bc-media-api-1.0.0 on your computer, then you would enter:
 
/Developer/Brightcove/bc-media-api-1.0.0/lib

IMPORTANT: Ensure that the "recursive" checkbox is selected.

(10) Double-click the Other Linking Flags property in the Linking section of the Settings list.

(11) Add the following flag: 

	-ObjC

(12) Close Project Settings

====================
MEDIA DELIVERY TYPES 
====================

The Brightcove Media API allows you to retrieve media urls in three ways. BCMediaDeliveryTypeDefault 
returns your medias urls in the accounts default setting. Most accounts are setup as Streaming accounts 
that use Flash Media Server for delivery. The account could also be set to progressive download by default 
but it is not the norm. So this means that media urls fetched with this setting will most likely not 
be playable in the iOS player. The BCMediaDeliveryTypeHTTP type tries to find a media url that is 
available over HTTP. Your account must be setup for UDS, http://support.brightcove.com/en/docs/setting-video-delivery-options , 
to use this type. The last type is BCMediaDeliveryTypeHTTP_IOS, this asks the Media API to return 
media urls that point to Apple HTTP Streaming files. You will need to create renditions to support 
this new streaming format available through Brightcove. This is Apples preferred way to playback 
video on iOS devices as it puts less stress on carrier networks. It also allows the Apple player to 
adjust the rendition being played back as the network speed  changes.

===============
MEDIA API USAGE
===============

The BCMediaAPI class is a facade for all Brightcove Media API calls. This enables developers to instantiate it once for any needed calls:
 
    BCMediaAPI *bc = [[BCMediaAPI alloc] initWithReadToken:@"MyApiKey"];
 
Invocations are handled using Cocoa-style error pointers, thus the pattern for all invocations is as follows:

    (1) Create an NSError object if you desire error info (optional)
    (2) Invoke a BC Media API method which will return a BCVideo, BCPlaylist, or BCItemCollection
    (3) Check whether the returned BCObject is nil, and if so examine the NSError (if you used one)
    (4) If the returned BCObject was not nil, then access its properties according to your app's needs
 
======================
MEDIA API EXAMPLE CODE 
======================

// Don't forget to include this line in your source:
 #import "BCMediaAPI.h"

 BCMediaAPI *bc = [[BCMediaAPI alloc] initWithReadToken:@"MyApiKey"];

 NSError *err;
 BCVideo *video = [bc findVideoById:1234LL error:&err];
 
 if (!video)
 {
	// if the result is nil, and we sent the optional error argument,
	// then the error will be populated by all underlying errors reported
	// by the Brightcove server. We can use the following convenience method 
	// to dump the NSError's userInfo, where the underlying errors are reported, 
	// into an NSString for logging or other purposes:
 
	NSString *errStr = [bc getErrorsAsString:err];
	NSLog(errStr);
 }