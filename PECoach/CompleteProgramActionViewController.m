//
//  CompleteProgramActionViewController.m
//  PECoach
//

#import "CompleteProgramActionViewController.h"
#import "Asset.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "UILabel+PELabel.h"
#import "Analytics.h"

@implementation CompleteProgramActionViewController

#pragma mark - Properties

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = self.defaultSolidViewBackgroundColor;
  
  Asset *asset = [self.librarian assetForKey:kAssetKeyProgramCompletionText];
  
  CGFloat width = self.formScrollView.frame.size.width - (kUIViewHorizontalInset * 2);
  UILabel *label = [self formLabelWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, width, 0.0) text:asset.content];
  label.textColor = [UIColor whiteColor];
  label.font = self.defaultTextFont;
  
  [label resizeHeightAndWrapTextToFitWithinWidth:label.frame.size.width];
  [self.formScrollView addSubview:label];
  
  [self resizeContentViewToFitForScrollView:self.formScrollView];
  [self.saveButton setTitle:NSLocalizedString(@"Quit PE Coach", nil) forState:UIControlStateNormal];
  self.saveButton.enabled = NO;
  self.saveButton.hidden = YES;
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"COMPLETE PROGRAM ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [super dealloc];
}

#pragma mark - Instance Methods

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  // According to the spec, we're supposed to quit the app here, but according to Apple's documentation,
  // there is no officially supported way of doing that:
  // http://developer.apple.com/library/ios/#qa/qa1561/_index.html
}

@end
