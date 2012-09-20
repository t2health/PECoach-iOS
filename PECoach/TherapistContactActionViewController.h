//
//  TherapistContactActionViewController.h
//  PECoach
//

#import "FormActionViewController.h"

@interface TherapistContactActionViewController : FormActionViewController {
  UILabel *nameLabel_;
  UILabel *phoneLabel_;
  UILabel *cellLabel_;
  UILabel *emailLabel_;
  
  UITextField *nameTextField_;
  UITextField *phoneTextField_;
  UITextField *cellTextField_;
  UITextField *emailTextField_;
  
  UIButton *editButton_;
}

// Properties
@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) UILabel *phoneLabel;
@property(nonatomic, retain) UILabel *cellLabel;
@property(nonatomic, retain) UILabel *emailLabel;

@property(nonatomic, retain) UITextField *nameTextField;
@property(nonatomic, retain) UITextField *phoneTextField;
@property(nonatomic, retain) UITextField *cellTextField;
@property(nonatomic, retain) UITextField *emailTextField;

@property(nonatomic, retain) UIButton *editButton;

// UI Actions
- (void)handleSaveButtonTapped:(id)sender;
- (void)handleEditButtonTapped:(id)sender;
- (void)handleAddToContactsButtonTapped:(id)sender;
- (void)handleEmailTappedGesture:(UIGestureRecognizer *)gestureRecognizer;
- (void)handlePhoneNumberTappedGesture:(UIGestureRecognizer *)gestureRecognizer;

// Instance Methods
- (void)loadContactInfo;
 
@end
