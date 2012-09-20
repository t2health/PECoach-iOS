//
//  AssessSituationsActionViewController.m
//  PECoach
//

#import "AssessSituationsActionViewController.h"
#import "PECoachConstants.h"
#import "Situation.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation AssessSituationsActionViewController

#pragma mark - Properties

@synthesize situations = situations_;
@synthesize SUDSTextFields = SUDSTextFields_;

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
    SUDSTextFields_ = [[NSMutableArray alloc] initWithCapacity:[situations_ count]];
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = self.defaultSolidViewBackgroundColor;
  
  CGFloat textFieldWidth = kUITextFieldSUDSWidth;
  CGFloat labelWidth = self.formScrollView.frame.size.width - textFieldWidth - kUIViewHorizontalMargin - (kUIViewHorizontalInset * 2);
  
  NSString *headingTitle = NSLocalizedString(@"HIERARCHY", nil);
  UILabel *headingLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, labelWidth, kUITextFieldDefaultHeight) text:headingTitle];    
  headingLabel.textColor = [UIColor grayColor];
  [self.formScrollView addSubview:headingLabel];
  
  NSString *textFieldHeadingTitle = NSLocalizedString(@"SUDS", nil);
  UILabel *textFieldHeadingLabel = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, textFieldWidth, kUITextFieldDefaultHeight) text:textFieldHeadingTitle];
  textFieldHeadingLabel.textColor = headingLabel.textColor;
  textFieldHeadingLabel.textAlignment = UITextAlignmentCenter;
  
  [textFieldHeadingLabel positionToTheRightOfView:headingLabel margin:kUIViewHorizontalMargin];
  [self.formScrollView addSubview:textFieldHeadingLabel];
  
  __block UIView *lastView = headingLabel;
  [self.SUDSTextFields removeAllObjects];
                                
  [self.situations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    Situation *situation = (Situation *)obj;
      UILabel *label = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, labelWidth, kUITextFieldDefaultHeight) text:situation.title];  
      [label setTextColor:[UIColor whiteColor]];   
    [label positionBelowView:lastView margin:kUIViewVerticalMargin];

    UITextField *textField = [self SUDSTextFieldWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, textFieldWidth, kUITextFieldDefaultHeight) text:[situation.finalSUDSRating stringValue]];
      [textField alignTopWithView:label];
      [textField setTextColor:[UIColor blackColor]]; 
    [textField positionToTheRightOfView:label margin:kUIViewHorizontalMargin];
    
    [self.formScrollView addSubview:label];
    [self.formScrollView addSubview:textField];

    [self.SUDSTextFields addObject:textField];
    lastView = label;
  }];
  
  [self resizeContentViewToFitForScrollView:self.formScrollView];
  self.saveButton.enabled = YES;
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [super viewDidUnload];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [situations_ release];
  [SUDSTextFields_ release];
  
  [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"ASSESS SITUATIONS ACTION VIEW"];
    [super viewDidAppear:animated];
}

#pragma mark - Instance Methods

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  if ([self validateSUDSFields:self.SUDSTextFields] == NO) {
    UIAlertView *alertView = [self alertViewForInvalidSUDSRating];
    [alertView show];
    return;
  }
  
  [self.SUDSTextFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    UITextField *textField = (UITextField *)obj;
    Situation *situation = [self.situations objectAtIndex:idx];
    situation.finalSUDSRating = [NSNumber numberWithInteger:[textField.text integerValue]];
  }];
  
  [self.navigationController popViewControllerAnimated:YES];
}

@end
