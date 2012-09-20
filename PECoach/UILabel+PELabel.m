//
//  UILabel+PELabel.m
//  PECoach
//

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
