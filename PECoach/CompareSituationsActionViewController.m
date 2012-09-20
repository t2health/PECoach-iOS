//
//  CompareSituationsActionViewController.m
//  PECoach
//

#import "CompareSituationsActionViewController.h"
#import "GraphSituationsActionViewController.h"
#import "PECoachConstants.h"
#import "Situation.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation CompareSituationsActionViewController

#pragma mark - Properties

@synthesize situations = situations_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action:situations
 */
- (id)initWithSession:(Session *)session action:(Action *)action situations:(NSSet *)situations {
  self = [super initWithSession:session action:action];
  if (self != nil) {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    situations_ = [[situations sortedArrayUsingDescriptors:sortDescriptors] retain];
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = self.defaultSolidViewBackgroundColor;

  CGFloat labelWidth = self.formScrollView.frame.size.width - (kUITextFieldSUDSWidth * 2) - (kUIViewHorizontalMargin * 2) - (kUIViewHorizontalInset * 2);
  
  NSString *headingTitle = NSLocalizedString(@"HIERARCHY", nil);
  UILabel *headingLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, labelWidth, kUITextFieldDefaultHeight) text:headingTitle];    
  headingLabel.textColor = [UIColor grayColor];
  [self.formScrollView addSubview:headingLabel];
  
  NSString *startTitle = NSLocalizedString(@"START", nil);
  UILabel *startLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, kUITextFieldSUDSWidth, kUITextFieldDefaultHeight) text:startTitle];    
  startLabel.textAlignment = UITextAlignmentCenter;
  startLabel.textColor = [UIColor grayColor];
  [startLabel positionToTheRightOfView:headingLabel margin:kUIViewHorizontalMargin];
  [self.formScrollView addSubview:startLabel];
  
  NSString *endTitle = NSLocalizedString(@"FINAL", nil);
  UILabel *endLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, kUITextFieldSUDSWidth, kUITextFieldDefaultHeight) text:endTitle];    
  endLabel.textAlignment = UITextAlignmentCenter;
  endLabel.textColor = [UIColor grayColor];
  [endLabel positionToTheRightOfView:startLabel margin:kUIViewHorizontalMargin];
  [self.formScrollView addSubview:endLabel];

  __block UIView *lastView = headingLabel;
  
  [self.situations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    Situation *situation = (Situation *)obj;
    UILabel *label = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, labelWidth, kUITextFieldDefaultHeight) text:situation.title];  
    [label setTextColor:[UIColor whiteColor]];  
    [label positionBelowView:lastView margin:kUIViewVerticalMargin];
    
    UILabel *startLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, kUITextFieldSUDSWidth, kUITextFieldDefaultHeight) text:[situation.initialSUDSRating stringValue]];    
      startLabel.textAlignment = UITextAlignmentCenter;
      [startLabel setTextColor:[UIColor whiteColor]]; 
    [startLabel positionToTheRightOfView:label margin:kUIViewHorizontalMargin];
    [startLabel alignTopWithView:label];
    
    UILabel *endLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, kUITextFieldSUDSWidth, kUITextFieldDefaultHeight) text:[situation.finalSUDSRating stringValue]];    
      endLabel.textAlignment = UITextAlignmentCenter;
      [endLabel setTextColor:[UIColor whiteColor]]; 
    [endLabel positionToTheRightOfView:startLabel margin:kUIViewHorizontalMargin];
    [endLabel alignTopWithView:startLabel];

    [self.formScrollView addSubview:label];
    [self.formScrollView addSubview:startLabel];
    [self.formScrollView addSubview:endLabel];
    
    lastView = label;
  }];
  
  [self resizeContentViewToFitForScrollView:self.formScrollView];
  [self.saveButton setTitle:NSLocalizedString(@"Graph", nil) forState:UIControlStateNormal];
  self.saveButton.enabled = YES;
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"COMPARE SITUATIONS ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [situations_ release];
  
  [super dealloc];
}

#pragma mark - Instance Methods

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  GraphSituationsActionViewController *viewController = [[GraphSituationsActionViewController alloc] initWithSession:self.session action:self.action situationsArray:self.situations];
  viewController.showDoneButton = NO;
  viewController.showHomeButton = NO;
  
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

@end
