//
//  UIView+Positionable.h
//  PECoach
//

#import <Foundation/Foundation.h>

@interface UIView (PEView)

- (void)positionAboveView:(UIView *)reference margin:(CGFloat)margin;
- (void)positionBelowView:(UIView *)reference margin:(CGFloat)margin;
- (void)positionToTheRightOfView:(UIView *)reference margin:(CGFloat)margin;
- (void)positionToTheLeftOfView:(UIView *)reference margin:(CGFloat)margin;
- (void)positionAtTheBottomofView:(UIView *)reference margin:(CGFloat)margin;

- (void)alignLeftWithView:(UIView *)reference;
- (void)alignRightWithView:(UIView *)reference;
- (void)alignTopWithView:(UIView *)reference;
- (void)alignBottomWithView:(UIView *)reference;
- (void)alignVerticalWithView:(UIView *)reference;
- (void)alignHorizontalWithView:(UIView *)reference;

- (void)moveToPoint:(CGPoint)point;
- (void)moveToRightEdgeOrigin:(CGFloat)origin;
- (void)moveToLeftEdgeOrigin:(CGFloat)origin;

- (void)centerHorizontallyInView:(UIView *)reference;
- (void)centerVerticallyInView:(UIView *)reference;

- (void)resizeHeightToContainSubviewsWithMargin:(CGFloat)margin;

@end
