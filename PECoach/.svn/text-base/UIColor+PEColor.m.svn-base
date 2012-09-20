//
//  PEColor.m
//  PECoach
//

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
