//
//  ResetUserDataActionViewController.h
//  PECoach
//

#import "FormActionViewController.h"

@interface ResetUserDataActionViewController : FormActionViewController<UIAlertViewDelegate> {
  UILabel *confirmationLabel_;
  UIButton *clearDataButton_;
}

// Properties
@property(nonatomic, retain) UILabel *confirmationLabel;
@property(nonatomic, retain) UIButton *clearDataButton;

// UI Actions
- (void)handleClearButtonTapped:(id)sender;

@end
