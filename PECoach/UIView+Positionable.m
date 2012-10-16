//
//  UIView+Positionable.m
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
#import "UIView+Positionable.h"

@implementation UIView (PEView)

/**
 *  positionAboveView:margin
 */
- (void)positionAboveView:(UIView *)reference margin:(CGFloat)margin {
  CGRect frame = self.frame;
  frame.origin.y = reference.frame.origin.y - frame.size.height - margin;
  self.frame = frame;
}

/**
 *  positionBelowView:margin
 */
- (void)positionBelowView:(UIView *)reference margin:(CGFloat)margin {
  CGRect frame = self.frame;
  frame.origin.y = reference.frame.origin.y + reference.frame.size.height + margin;
  self.frame = frame;
}

/**
 *  positionToTheRightOfView:margin
 */
- (void)positionToTheRightOfView:(UIView *)reference margin:(CGFloat)margin {
  CGRect frame = self.frame;
  frame.origin.x = reference.frame.origin.x + reference.frame.size.width + margin;
  self.frame = frame;
}

/**
 *  positionToTheLeftOfView:margin
 */
- (void)positionToTheLeftOfView:(UIView *)reference margin:(CGFloat)margin {
  CGRect frame = self.frame;
  frame.origin.x = reference.frame.origin.x - frame.size.width - margin;
  self.frame = frame;
}

/**
 *  positionAtTheBottomofView:margin
 */
- (void)positionAtTheBottomofView:(UIView *)reference margin:(CGFloat)margin {
  CGRect frame = self.frame;
  frame.origin.y = reference.frame.size.height - frame.size.height - margin;
  self.frame = frame;
}

/**
 *  alignLeftWithView
 */
- (void)alignLeftWithView:(UIView *)reference {
  CGRect frame = self.frame;
  frame.origin.x = reference.frame.origin.x;
  self.frame = frame;
}

/**
 *  alignRightWithView
 */
- (void)alignRightWithView:(UIView *)reference {
  CGRect frame = self.frame;
  CGFloat referenceRight = reference.frame.origin.x + reference.frame.size.width;
  CGFloat ourRight = frame.origin.x + frame.size.width;
  
  frame.origin.x += (referenceRight - ourRight);
  self.frame = frame;
}

/**
 *  alignTopWithView
 */
- (void)alignTopWithView:(UIView *)reference {
  CGRect frame = self.frame;
  frame.origin.y = reference.frame.origin.y;
  self.frame = frame;
}

/**
 *  alignBottomWithView
 */
- (void)alignBottomWithView:(UIView *)reference {
  CGRect frame = self.frame;
  CGFloat referenceBottom = reference.frame.origin.y + reference.frame.size.height;
  CGFloat ourBottom = frame.origin.y + frame.size.height;
  
  frame.origin.y += (referenceBottom - ourBottom);
  self.frame = frame;
}

/**
 *  alignVerticalWithView
 */
- (void)alignVerticalWithView:(UIView *)reference {
  CGRect frame = self.frame;
  frame.origin.y = reference.frame.origin.y + ((reference.frame.size.height - frame.size.height) / 2);
  
  self.frame = frame;
}


/**
 *  alignHorizontalWithView
 */
- (void)alignHorizontalWithView:(UIView *)reference {
  CGRect frame = self.frame;
  frame.origin.x = reference.frame.origin.x + ((reference.frame.size.width - frame.size.width) / 2);
  
  self.frame = frame;
}

/**
 *  moveToPoint
 */
- (void)moveToPoint:(CGPoint)point {
  CGRect frame = self.frame;
  frame.origin = point;
  
  self.frame = frame;
}

/**
 *  moveToRightEdgeOrigin
 */
- (void)moveToRightEdgeOrigin:(CGFloat)origin {
  CGRect frame = self.frame;
  frame.origin.x = origin - frame.size.width;
  
  self.frame = frame;
}

/**
 *  moveToLeftEdgeOrigin
 */
- (void)moveToLeftEdgeOrigin:(CGFloat)origin {
  CGRect frame = self.frame;
  frame.origin.x = origin;
  
  self.frame = frame;
}

/**
 *  centerHorizontallyInView
 */
- (void)centerHorizontallyInView:(UIView *)reference {
  CGRect frame = self.frame;
  frame.origin.x = (reference.frame.size.width - frame.size.width) / 2;
  self.frame = frame;
}


/**
 *  centerVerticallyInView
 */
- (void)centerVerticallyInView:(UIView *)reference {
  CGRect frame = self.frame;
  frame.origin.y = (reference.frame.size.height - frame.size.height) / 2;
  self.frame = frame;
}

/**
 *  resizeHeightToContainSubviewsWithMargin
 */
- (void)resizeHeightToContainSubviewsWithMargin:(CGFloat)margin {
  CGRect frame = self.frame;
  __block CGFloat height = 0.0;
  
  [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    UIView *child = (UIView *)obj;
    if (child.isHidden == NO) {
      height = MAX(height, child.frame.origin.y + child.frame.size.height);
    }
  }];
  
  frame.size.height = (height + margin);
  self.frame = frame;
}

@end
