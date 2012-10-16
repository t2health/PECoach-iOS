//
//  PEColor.m
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
#import "UIColor+PEColor.h"

@implementation UIColor (PEColor)

/**
 *  colorWithRGBString
 */
+ (UIColor *)colorWithRGBString:(NSString *)RGB {
  NSArray *components = [RGB componentsSeparatedByString:@","];
  
  CGFloat red = [[components objectAtIndex:0] floatValue] / 255.0;
  CGFloat green = [[components objectAtIndex:1] floatValue] / 255.0;
  CGFloat blue = [[components objectAtIndex:2] floatValue] / 255.0;
  
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

/**
 *  applicationColor
 */
+ (UIColor *)applicationColor {
  return [UIColor colorWithRed:0.0/255.0 green:18.0/255.0 blue:98.0/255.0 alpha:1.0];
}

@end
