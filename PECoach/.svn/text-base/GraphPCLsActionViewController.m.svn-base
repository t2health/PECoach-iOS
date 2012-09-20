//
//  GraphPCLsActionViewController.m
//  PECoach
//
//  Created by Brian Doherty on 6/7/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import "GraphPCLsActionViewController.h"
#import "QuestionnaireAction.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "Session.h"
#import "UIView+Positionable.h"
#import "Analytics.h"



@implementation GraphPCLsActionViewController

#pragma mark - Properties

@synthesize dateFormatter = dateFormatter_;
@synthesize pclScores = pclScores_;
@synthesize scrollView = scrollView_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action:pclScores
 */
- (id)initWithSession:(Session *)session action:(Action *)action pclScoresArray:(NSArray *)pclScores {
    self = [super initWithSession:session action:action];
    if (self != nil) {
        pclScores_ = [pclScores retain];
        
        dateFormatter_ = [[NSDateFormatter alloc] init];
        [dateFormatter_ setDateStyle:NSDateFormatterShortStyle];
    }
    
    return self;
}
/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 06/07/2012 This is a blatant rip off of GraphSituationsActionViewController....
    // ....easier than trying to retrofit that to handle SUDS and PCLs
    
    // * Would definitely be better to migrate this over to using something like CorePlot, or even just a quick and dirty
    // * custom drawing routine, but one big benefit of using UIKit controls for creating this graph is that we get
    // * accessibility support for free. 
    
    // Cheating here on the height to simplify layout in the scrollview.
    CGFloat contentHeight = 324.0;
    NSString *xAxisText = NSLocalizedString(@"DATES", nil);
    NSString *yAxisText = NSLocalizedString(@"PCL SCORES", nil);
    UIFont *axisLabelFont = [UIFont boldSystemFontOfSize:12.0];
    UIFont *tickLabelFont = [UIFont boldSystemFontOfSize:10.0];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[self contentFrame]];
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = [UIColor whiteColor];  
    
    // X Axis Label
    CGSize xAxisLabelSize = [xAxisText sizeWithFont:axisLabelFont];
    UILabel *xAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, contentHeight - kUIViewVerticalMargin, xAxisLabelSize.width, xAxisLabelSize.height)];
    xAxisLabel.backgroundColor = [UIColor clearColor];
    xAxisLabel.font = axisLabelFont;
    xAxisLabel.text = xAxisText;
    xAxisLabel.textColor = [UIColor grayColor];
    
    [xAxisLabel centerHorizontallyInView:scrollView];
    //[xAxisLabel positionAtTheBottomofView:scrollView margin:kUIViewVerticalMargin];
    // Raise it up a bit...above routine is sliding it off the bottom of the screen
    CGRect curFrame = xAxisLabel.frame;
    curFrame.origin.y -= 15;
    xAxisLabel.frame = curFrame;
    
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
    CGSize tickLabelSize = [[[NSNumber numberWithInteger:kMaximumPCLScore] stringValue] sizeWithFont:tickLabelFont];
    
    // Working height of the graph area.
    CGFloat graphHeight = xAxisLabel.frame.origin.y - kUIViewVerticalMargin - tickLabelSize.height - kUIViewVerticalInset;
    
    NSArray *yAxisTickValues = [NSArray arrayWithObjects:[NSNumber numberWithInteger:kMaximumPCLScore], 
                                [NSNumber numberWithInteger:(kMaximumPCLScore / 2)], 
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
        tickLabel.textColor = [UIColor blueColor];
        
        [tickLabel positionToTheRightOfView:yAxisLabel margin:kUIViewHorizontalMargin];
        [scrollView addSubview:tickLabel];
        [tickLabel release];
    }];
    
    // y Axis Line
    UIView *yAxisLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kUIViewVerticalInset + (tickLabelSize.height / 2), 1.0, graphHeight)];
    yAxisLineView.backgroundColor = [UIColor blueColor];
    
    [yAxisLineView positionToTheRightOfView:yAxisLabel margin:kUIViewHorizontalMargin + tickLabelSize.width + 2.0];
    [scrollView addSubview:yAxisLineView];
    
    // x Axis Line
    CGFloat barWidth = 15.0;
    CGFloat graphWidth = ([self.pclScores count] * barWidth * 2) + (([self.pclScores count] + 1) * barWidth);
    
    CGRect xAxisLineViewFrame = CGRectMake(yAxisLineView.frame.origin.x, yAxisLineView.frame.origin.y + yAxisLineView.frame.size.height, graphWidth, 1.0);
    UIView *xAxisLineView = [[UIView alloc] initWithFrame:xAxisLineViewFrame];
    xAxisLineView.backgroundColor = [UIColor blueColor];
    
    [scrollView addSubview:xAxisLineView];
    
    // PCL Score bars - This is where we plot the graph
    CGFloat xAxisLineYOrigin = xAxisLineView.frame.origin.y;
    
    // We want to graph from the oldest to the newest (they are stored just the opposite...so we Reverse it)
    // Actually, it doesn't really matter how we traverse the array...the math places the bars in index order!
    // So we reverse that by using ([self.pclScores count] - idx - 1]
    //[self.pclScores enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //  NSLog(@"normal enumeration");
    [self.pclScores enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        QuestionnaireAction *questionnaireAction = (QuestionnaireAction *)obj;
        
        // Get the horizontal position...we are transposing the index with: ([self.pclScores count]-idx-1)
        CGFloat xOffset = (barWidth * 3 * ([self.pclScores count]-idx-1)) + xAxisLineView.frame.origin.x;
        
        CGFloat barXOffset = xOffset + barWidth + barWidth;
        NSInteger score = [questionnaireAction score];
        UIColor *backgroundColor = [UIColor blackColor];
        NSString *accessibilityPrefix = NSLocalizedString(@"PCL Score", nil);
        
        CGFloat normalizedHeight = (graphHeight / kMaximumPCLScore) * score;
        UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(barXOffset, xAxisLineYOrigin - normalizedHeight, barWidth, normalizedHeight)];
        barView.backgroundColor = backgroundColor;
        barView.isAccessibilityElement = YES;
        barView.accessibilityLabel = [NSString stringWithFormat:@"%@ %i", accessibilityPrefix, score];
        barView.accessibilityTraits = UIAccessibilityTraitNone;
                
        [scrollView addSubview:barView];
        [barView release];
 
        
        UILabel *tickLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + barWidth, xAxisLineYOrigin + 2.0, barWidth * 2.5, tickLabelSize.height)];
        tickLabel.backgroundColor = [UIColor clearColor];
        tickLabel.font = tickLabelFont;
        tickLabel.text = [self.dateFormatter stringFromDate:questionnaireAction.completionDate];;
        tickLabel.textAlignment = UITextAlignmentCenter;
        tickLabel.textColor = [UIColor blueColor];
        
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
    [Analytics logEvent:@"GRAPH PCL SCORES"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
    [dateFormatter_ release];
    [pclScores_ release];
    
    [super dealloc];
}


@end
