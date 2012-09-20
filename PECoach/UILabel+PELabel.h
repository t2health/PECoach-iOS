//
//  UILabel+PELabel.h
//  PECoach
//

#import <Foundation/Foundation.h>


@interface UILabel (UILabel_PELabel)

- (void)resizeWidthAndWrapTextToFitWithinHeight:(CGFloat)height;
- (void)resizeHeightAndWrapTextToFitWithinWidth:(CGFloat)width;

@end
