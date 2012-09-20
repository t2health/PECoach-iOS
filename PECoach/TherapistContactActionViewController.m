//
//  TherapistContactActionViewController.m
//  PECoach
//

#import "TherapistContactActionViewController.h"
#import "PECoachConstants.h"
#import "UIView+Positionable.h"
#import "Analytics.h"

@implementation TherapistContactActionViewController

#pragma mark - Properties

@synthesize nameLabel = nameLabel_;
@synthesize phoneLabel = phoneLabel_;
@synthesize cellLabel = cellLabel_;
@synthesize emailLabel = emailLabel_;

@synthesize nameTextField = nameTextField_;
@synthesize phoneTextField = phoneTextField_;
@synthesize cellTextField = cellTextField_;
@synthesize emailTextField = emailTextField_;

@synthesize editButton = editButton_;

#pragma mark - Lifecycle

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  CGFloat xOrigin = kUIViewHorizontalInset;
  __block CGFloat yOrigin = kUIViewVerticalInset;
  CGFloat labelWidth = 60.0;
  CGFloat fieldWidth = self.formScrollView.frame.size.width - labelWidth - (kUIViewHorizontalInset * 2) - kUIViewHorizontalMargin;

  NSArray *labels = [NSArray arrayWithObjects:NSLocalizedString(@"Name:", @""),
                                              NSLocalizedString(@"Phone:", @""), 
                                              NSLocalizedString(@"Cell:", @""),
                                              NSLocalizedString(@"Email:", @""), nil];
  
  // Layout the labels and text fields. Note that for the first row "PIN", we layout the text field
  // to the right of the label. For all other fields we layout the text field below the label.
  [labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    UILabel *label = [self formLabelWithFrame:CGRectMake(xOrigin, yOrigin, labelWidth, kUITextFieldDefaultHeight) text:obj]; 
      label.textColor = [UIColor whiteColor];
    [self.formScrollView addSubview:label];
          
    UITextField *textField = [self formTextFieldWithFrame:CGRectMake(xOrigin, yOrigin, fieldWidth, kUITextFieldDefaultHeight) text:nil];
    textField.hidden = YES;
    
    [textField positionToTheRightOfView:label margin:kUIViewHorizontalMargin];
    [self.formScrollView addSubview:textField];
    
    UILabel *fieldLabel = [self formLabelWithFrame:textField.frame text:nil];
    fieldLabel.font = [UIFont systemFontOfSize:self.defaultTableCellFont.pointSize];
    fieldLabel.userInteractionEnabled = YES;
      fieldLabel.textColor = [UIColor whiteColor];
    
    [self.formScrollView addSubview:fieldLabel];
    
    switch (idx) {
      case 0: {
        self.nameLabel = fieldLabel;
        self.nameTextField = textField;
        break;
      }
        
      case 1: {
        self.phoneLabel = fieldLabel;
        self.phoneTextField = textField;
        self.phoneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        break;
      }
        
      case 2: {
        self.cellLabel = fieldLabel;
        self.cellTextField = textField;
        self.cellTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        break;
      }
        
      case 3: {
        self.emailLabel = fieldLabel;
        self.emailTextField = textField;
        self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        break;
      }
        
    }
    
    if (idx == 1 || idx == 2) {
      UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoneNumberTappedGesture:)];
      [fieldLabel addGestureRecognizer:tapRecognizer];
      [tapRecognizer release];
    } else if (idx == 3) {
      UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEmailTappedGesture:)];
      [fieldLabel addGestureRecognizer:tapRecognizer];
      [tapRecognizer release];
    }
    
    yOrigin += (kUITextFieldDefaultHeight + kUIViewVerticalMargin);
  }];
  
  UIButton *editButton = [self buttonWithTitle:NSLocalizedString(@"Edit", nil)];
  editButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  [editButton addTarget:self action:@selector(handleEditButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  
  CGRect buttonFrame = editButton.frame;
  buttonFrame.origin.x = (self.view.frame.size.width - buttonFrame.size.width) / 2;
  buttonFrame.origin.y = self.saveButton.frame.origin.y;
  editButton.frame = buttonFrame;

  self.editButton = editButton;
  [self.view addSubview:self.editButton];
  
  self.saveButton.enabled = YES;
  self.saveButton.hidden = YES;
  
  [self resizeContentViewToFitForScrollView:self.formScrollView];
  [self loadContactInfo];
  
  // If there is no contact info, then switch to edit mode:
  if ([self.nameTextField.text length] == 0) {
    [self handleEditButtonTapped:self];
  }
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.nameLabel = nil;
  self.phoneLabel = nil;
  self.cellLabel = nil;
  self.emailLabel = nil;

  self.nameTextField = nil;
  self.phoneTextField = nil;
  self.cellTextField = nil;
  self.emailTextField = nil;
  
  self.editButton = nil;

  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"THERAPIST CONTACT ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [nameLabel_ release];
  [phoneLabel_ release];
  [cellLabel_ release];
  [emailLabel_ release];
  
  [nameTextField_ release];
  [phoneTextField_ release];
  [cellTextField_ release];
  [emailTextField_ release];

  [editButton_ release];

  [super dealloc];
}

#pragma mark - UI Actions

/**
 *  handleSaveButtontapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

  [userDefaults setObject:self.nameTextField.text forKey:kUserDefaultsKeyTherapistContactName];
  [userDefaults setObject:self.phoneTextField.text forKey:kUserDefaultsKeyTherapistContactPhone];
  [userDefaults setObject:self.cellTextField.text forKey:kUserDefaultsKeyTherapistContactCell];
  [userDefaults setObject:self.emailTextField.text forKey:kUserDefaultsKeyTherapistContactEmail];
  [userDefaults synchronize];
  
  [self loadContactInfo];

  self.nameLabel.hidden = NO;
  self.phoneLabel.hidden = NO;
  self.cellLabel.hidden = NO;
  self.emailLabel.hidden = NO;
  self.editButton.hidden = NO;
  
  self.nameTextField.hidden = YES;
  self.phoneTextField.hidden = YES;
  self.cellTextField.hidden = YES;
  self.emailTextField.hidden = YES;
  self.saveButton.hidden = YES;
}
  
/**
 *  handleEditButtontapped
 */
- (void)handleEditButtonTapped:(id)sender {
  self.nameLabel.hidden = YES;
  self.phoneLabel.hidden = YES;
  self.cellLabel.hidden = YES;
  self.emailLabel.hidden = YES;
  self.editButton.hidden = YES;

  self.nameTextField.hidden = NO;
  self.phoneTextField.hidden = NO;
  self.cellTextField.hidden = NO;
  self.emailTextField.hidden = NO;
  self.saveButton.hidden = NO;
}

/**
 *  handleAddToContactsButtonTapped
 */
- (void)handleAddToContactsButtonTapped:(id)sender {
}

/**
 *  handlePhoneNumberTappedGesture
 */
- (void)handlePhoneNumberTappedGesture:(UIGestureRecognizer *)gestureRecognizer {
  UILabel *label = (UILabel *)gestureRecognizer.view;
  if ([label.text length] > 2) {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", label.text]];
    [[UIApplication sharedApplication] openURL:URL];
  }
}

/**
 *  handleEmailTappedGesture
 */
- (void)handleEmailTappedGesture:(UIGestureRecognizer *)gestureRecognizer {
  UILabel *label = (UILabel *)gestureRecognizer.view;
  if ([label.text length] > 2) {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", label.text]];
    [[UIApplication sharedApplication] openURL:URL];
  }
}

#pragma mark - Instance Methods

/**
 *  loadContactInfo
 */
- (void)loadContactInfo {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  self.nameLabel.text = [userDefaults objectForKey:kUserDefaultsKeyTherapistContactName];
  self.nameTextField.text = self.nameLabel.text;
  
  self.phoneLabel.text = [userDefaults objectForKey:kUserDefaultsKeyTherapistContactPhone];
  self.phoneTextField.text = self.phoneLabel.text;

  self.cellLabel.text = [userDefaults objectForKey:kUserDefaultsKeyTherapistContactCell];
  self.cellTextField.text = self.cellLabel.text;

  self.emailLabel.text = [userDefaults objectForKey:kUserDefaultsKeyTherapistContactEmail];
  self.emailTextField.text = self.emailLabel.text;
}

@end