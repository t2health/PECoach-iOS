//
//  Visual.h
//  Breathe
//
//  Created by Roger Reeder on 1/29/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Visual : NSObject {
	NSString	*name;
	NSString	*description;
	NSString	*bundleName;
	NSString	*postFix;
	NSString	*overlayFile;
	NSString	*backgroundFile;
	NSString	*thumbName;
	BOOL		staticImage;
	int			numberOfFrames;
	CGFloat		aspect;
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *bundleName;
@property(nonatomic, copy) NSString *postFix;
@property(nonatomic, copy) NSString *thumbName;
@property(nonatomic)	   BOOL staticImage;
@property(nonatomic, copy) NSString *overlayFile;
@property(nonatomic, copy) NSString *backgroundFile;
@property(nonatomic)	   int numberOfFrames;
@property(nonatomic)	   CGFloat aspect;

- (id)initWithName:(NSString *)n 
	   description:(NSString *)desc 
		bundleName:(NSString *)bundle
		   postFix:(NSString *)post 
	numberOfFrames:(int)frames 
	   overlayFile:(NSString *)overlay 
	   backgroundFile:(NSString *)background 
		 thumbName:(NSString *)thumb
	   staticImage:(BOOL)sImg;
@end
