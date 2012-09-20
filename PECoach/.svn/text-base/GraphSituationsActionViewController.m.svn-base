//
//  GraphSituationsActionViewController.m
//  PECoach
//

#import "GraphSituationsActionViewController.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "Session.h"
#import "Situation.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation GraphSituationsActionViewController

#pragma mark - Properties

@synthesize situations = situations_;
@synthesize scrollView = scrollView_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action:situations
 */
- (id)initWithSession:(Session *)session action:(Action *)action situationsArray:(NSArray *)situations {
  self = [super initWithSession:session action:action];
  if (self != nil) {
    situations_ = [situations retain];
  }
   
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // * Would definitely be better to migrate this over to using something like CorePlot, or even just a quick and dirty
  // * custom drawing routine, but one big benefit of using UIKit controls for creating this graph is that we get
  // * accessibility support for free. 
  
  // Cheating here on the height to simplify layout in the scrollview.
  CGFloat contentHeight = 324.0;
  NSString *xAxisText = NSLocalizedString(@"HIERARCHY ITEMS", nil);
  NSString *yAxisText = NSLocalizedString(@"SUDS RATINGS", nil);
  UIFont *axisLabelFont = [UIFont boldSystemFontOfSize:12.0];
  UIFont *tickLabelFont = [UIFont boldSystemFontOfSize:10.0];
  
  NSArray *sessions = [self.librarian allSessions];
  Session *secondSession = [sessions count] > 2 ? [sessions objectAtIndex:1] : nil;
  UIColor *initialRatingColor = (secondSession != nil? secondSession.color : [UIColor grayColor]);
  UIColor *finalRatingColor = self.session.color;
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[self contentFrame]];
  scrollView.alwaysBounceHorizontal = YES;
  scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  scrollView.backgroundColor = self.defaultSolidViewBackgroundColor;
    
  // Primary legend info
  UIFont *legendFont = [UIFont systemFontOfSize:12.0];
  NSString *primaryLegendText = NSLocalizedString(@"Final Session SUDS", nil);
  CGSize primaryLabelSize = [primaryLegendText sizeWithFont:legendFont];
  UILabel *primaryLegendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, contentHeight - primaryLabelSize.height - kUIViewVerticalMargin, primaryLabelSize.width, primaryLabelSize.height)];
  primaryLegendLabel.backgroundColor = [UIColor clearColor];
  primaryLegendLabel.font = legendFont;
  primaryLegendLabel.text = primaryLegendText;
  
  [primaryLegendLabel centerHorizontallyInView:scrollView];
  [scrollView addSubview:primaryLegendLabel];
  
  UIView *primaryColorSwatchView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
  primaryColorSwatchView.backgroundColor = finalRatingColor;
  
  [primaryColorSwatchView positionToTheLeftOfView:primaryLegendLabel margin:kUIViewHorizontalMargin];
  [primaryColorSwatchView alignVerticalWithView:primaryLegendLabel];
  [scrollView addSubview:primaryColorSwatchView];
  
  // Secondary legend info
  NSString *secondaryLegendText = NSLocalizedString(@"Session 2 SUDS", nil);
  CGSize secondaryLabelSize = [secondaryLegendText sizeWithFont:legendFont];
  UILabel *secondaryLegendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, secondaryLabelSize.width, secondaryLabelSize.height)];
  secondaryLegendLabel.backgroundColor = [UIColor clearColor];
  secondaryLegendLabel.font = legendFont;
  secondaryLegendLabel.text = secondaryLegendText;
  
  [secondaryLegendLabel alignLeftWithView:primaryLegendLabel];
  [secondaryLegendLabel positionAboveView:primaryLegendLabel margin:kUIViewVerticalMargin];
  [scrollView addSubview:secondaryLegendLabel];
  
  UIView *secondaryColorSwatchView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
  secondaryColorSwatchView.backgroundColor = initialRatingColor;
  
  [secondaryColorSwatchView positionToTheLeftOfView:secondaryLegendLabel margin:kUIViewHorizontalMargin];
  [secondaryColorSwatchView alignVerticalWithView:secondaryLegendLabel];
  [scrollView addSubview:secondaryColorSwatchView];
  
  [secondaryColorSwatchView release];
  [secondaryLegendLabel release];
  
  [primaryColorSwatchView release];
  [primaryLegendLabel release];
  
  // X Axis Label
  CGSize xAxisLabelSize = [xAxisText sizeWithFont:axisLabelFont];
  UILabel *xAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, xAxisLabelSize.width, xAxisLabelSize.height)];
  xAxisLabel.backgroundColor = [UIColor clearColor];
  xAxisLabel.font = axisLabelFont;
  xAxisLabel.text = xAxisText;
  xAxisLabel.textColor = [UIColor grayColor];
  
  [xAxisLabel centerHorizontallyInView:scrollView];
  [xAxisLabel positionAboveView:secondaryLegendLabel margin:kUIViewVerticalMargin];
  [scrollView addSubview:xAxisLabel];
  
  // Y Axis Label
  CGSize yAxisLabelSize = [yAxisText sizeWithFont:axisLabelFont];
  UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, yAxisLabelSize.width, yAxisLabelSize.height)];
  yAxisLabel.backgroundColor = [UIColor clearColor];
  yAxisLabel.center = CGPointMake((yAxisLabelSize.height / 2) + kUIViewHorizontalMargin, kUIViewVerticalInset + ((xAxisLabel.frame.origin.y - kUIViewVerticalInset) / 2));
  yAxisLabel.font = axisLabelFont;
  yAxisLabel.text = yAxisText;
  yAxisLabel.textColor = xAxisLabel.textColor;
  yAxisLabel.transform = CGAffineTransformMakeRotation(-1 * (M_PI / 2));
  
  [scrollView addSubview:yAxisLabel];
  
  // Tick labels
  CGSize tickLabelSize = [[[NSNumber numberWithInteger:kMaximumSUDSRating] stringValue] sizeWithFont:tickLabelFont];
  
  // Working height of the graph area.
  CGFloat graphHeight = xAxisLabel.frame.origin.y - kUIViewVerticalMargin - tickLabelSize.height - kUIViewVerticalInset;
  
  NSArray *yAxisTickValues = [NSArray arrayWithObjects:[NSNumber numberWithInteger:kMaximumSUDSRating], 
                                                       [NSNumber numberWithInteger:(kMaximumSUDSRating / 2)], 
                                                       [NSNumber numberWithInteger:0], nil];
  
  CGFloat tickVerticalSpacing = [yAxisTickValues count] > 2 ? graphHeight / ([yAxisTickValues count] - 1) : graphHeight;
  
  // y Axis Tick Labels
  [yAxisTickValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSNumber *tickValue = (NSNumber *)obj;
    UILabel *tickLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, kUIViewVerticalInset + (tickVerticalSpacing * idx), tickLabelSize.width, tickLabelSize.height)];
    tickLabel.backgroundColor = [UIColor clearColor];
    tickLabel.font = tickLabelFont;
    tickLabel.text = [tickValue stringValue];
    tickLabel.textAlignment = UITextAlignmentRight;
    tickLabel.textColor = self.session.color;
    
    [tickLabel positionToTheRightOfView:yAxisLabel margin:kUIViewHorizontalMargin];
    [scrollView addSubview:tickLabel];
    [tickLabel release];
  }];
  
  // y Axis Line
  UIView *yAxisLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kUIViewVerticalInset + (tickLabelSize.height / 2), 1.0, graphHeight)];
  yAxisLineView.backgroundColor = self.session.color;
  
  [yAxisLineView positionToTheRightOfView:yAxisLabel margin:kUIViewHorizontalMargin + tickLabelSize.width + 2.0];
  [scrollView addSubview:yAxisLineView];
  
  // x Axis Line
  CGFloat barWidth = 10.0;
  CGFloat graphWidth = ([self.situations count] * barWidth * 2) + (([self.situations count] + 1) * barWidth);
  
  CGRect xAxisLineViewFrame = CGRectMake(yAxisLineView.frame.origin.x, yAxisLineView.frame.origin.y + yAxisLineView.frame.size.height, graphWidth, 1.0);
  UIView *xAxisLineView = [[UIView alloc] initWithFrame:xAxisLineViewFrame];
  xAxisLineView.backgroundColor = self.session.color;

  [scrollView addSubview:xAxisLineView];
  
  // Situation bars
  CGFloat xAxisLineYOrigin = xAxisLineView.frame.origin.y;

  [self.situations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    Situation *situation = (Situation *)obj;
    
    CGFloat xOffset = (barWidth * 3 * idx) + xAxisLineView.frame.origin.x;
    
    for (NSInteger i = 0; i < 2; i++) {
      CGFloat barXOffset = xOffset + barWidth + (barWidth * i);
      NSInteger rating = [situation.initialSUDSRating integerValue];
      UIColor *backgroundColor = initialRatingColor;
      NSString *accessibilityPrefix = NSLocalizedString(@"Initial SUDS rating", nil);
      
      if (i == 1) {
        rating = [situation.finalSUDSRating integerValue];
        backgroundColor = finalRatingColor;
        accessibilityPrefix = NSLocalizedString(@"Final SUDS rating", nil);
      }

      CGFloat normalizedHeight = (graphHeight / kMaximumSUDSRating) * rating;
      UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(barXOffset, xAxisLineYOrigin - normalizedHeight, barWidth, normalizedHeight)];
      barView.backgroundColor = backgroundColor;
      barView.isAccessibilityElement = YES;
      barView.accessibilityLabel = [NSString stringWithFormat:@"%@ %i", accessibilityPrefix, rating];
      barView.accessibilityTraits = UIAccessibilityTraitNone;

      [scrollView addSubview:barView];
      [barView release];
    }
    
    UILabel *tickLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + barWidth, xAxisLineYOrigin + 2.0, barWidth * 2, tickLabelSize.height)];
    tickLabel.backgroundColor = [UIColor clearColor];
    tickLabel.font = tickLabelFont;
    tickLabel.text = [NSString stringWithFormat:@"%i", idx + 1];
    tickLabel.textAlignment = UITextAlignmentCenter;
    tickLabel.textColor = self.session.color;
    
    [scrollView addSubview:tickLabel];
    [tickLabel release];
  }];
  
  scrollView.contentSize = CGSizeMake(xAxisLineView.frame.origin.x + xAxisLineView.frame.size.width + kUIViewHorizontalInset, contentHeight);
  [self.view addSubview:scrollView];

  self.scrollView = scrollView;
  [scrollView release];

  [yAxisLineView release];
  [xAxisLineView release];
  
  [xAxisLabel release];
  [yAxisLabel release];
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.scrollView = nil;
  
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"GRAPH SITUATIONS ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [situations_ release];
  [scrollView_ release];
  
  [super dealloc];
}

#pragma mark - Instance Methods


@end
