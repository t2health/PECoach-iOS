//
//  GraphSituationsActionViewController.h
//  PECoach
//

#import "ActionViewController.h"

@class SUDSGraphView;

@interface GraphSituationsActionViewController : ActionViewController {
  NSArray *situations_;
  UIScrollView *scrollView_;
  SUDSGraphView *graphView_;
}

// Properties
@property(nonatomic, retain) NSArray *situations;
@property(nonatomic, retain) UIScrollView *scrollView;

// Initializers
- (id)initWithSession:(Session *)session action:(Action *)action situationsArray:(NSArray *)situations;

@end