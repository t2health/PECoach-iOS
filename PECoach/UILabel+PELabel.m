//
//  UILabel+PELabel.m
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
#import "UILabel+PELabel.h"


@implementation UILabel (UILabel_PELabel)

/**
 *  resizeWidthAndWrapTextToFitWithinHeight
 */
- (void)resizeWidthAndWrapTextToFitWithinHeight:(CGFloat)height {
  CGSize optimalSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:self.lineBreakMode]; 
  
  CGRect frame = self.frame;
  frame.size.width = optimalSize.width;
  frame.size.height = height;
  
  self.frame = frame;
  self.numberOfLines = optimalSize.height / self.font.lineHeight;
}

/**
 *  resizeHeightAndWrapTextToFitWithinWidth
 */
- (void)resizeHeightAndWrapTextToFitWithinWidth:(CGFloat)width {
  CGSize optimalSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:self.lineBreakMode]; 
    
  CGRect frame = self.frame;
  frame.size.width = width;
  frame.size.height = optimalSize.height;

  self.frame = frame;
  self.numberOfLines = optimalSize.height / self.font.lineHeight;
}

@end
