//
//  Visual.m
//  Breathe
//
//  Created by Roger Reeder on 1/29/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "Visual.h"


@implementation Visual
@synthesize name, description, bundleName, postFix, overlayFile, backgroundFile, numberOfFrames, thumbName, staticImage, aspect;

- (id)initWithName:(NSString *)n 
	   description:(NSString *)desc 
		bundleName:(NSString *)bundle
		   postFix:(NSString *)post
	numberOfFrames:(int)frames 
	   overlayFile:(NSString *)overlay 
	   backgroundFile:(NSString *)background 
		 thumbName:(NSString *)thumb 
	   staticImage:(BOOL)sImg {
	
	self.name = n;
	self.description = desc;
	self.bundleName = bundle;
	self.postFix = post;
	self.numberOfFrames = frames;
	self.overlayFile = overlay;
	self.backgroundFile = background;
	self.thumbName = thumb;
	self.staticImage = sImg;
	return self;
}
@end
