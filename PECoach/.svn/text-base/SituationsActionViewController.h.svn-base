//
//  CreateSituationsActionViewController.h
//  PECoach
//

#import "ActionTableViewController.h"

typedef enum {
  kSituationActionViewModeAppendSituations = 0,
  kSituationActionViewModeCreateSituations,
  kSituationActionViewModeEditSituations,
  kSituationActionViewModeListSituations,
  kSituationActionViewModeReviewSituations,
  kSituationActionViewModeSelectSituations,
} SituationActionViewMode;

@interface SituationsActionViewController : ActionTableViewController<UITextFieldDelegate> {
  UITextField *titleTextField_;
  UITextField *ratingTextField_;
  UIButton *saveButton_;
  
  SituationActionViewMode situationMode_;
  NSString *introLabelText_;
  BOOL showTableFooterView_;
  UITableViewCellSelectionStyle tableViewCellSelectionStyle_;
  NSArray *situations_;
}

// Properties
@property(nonatomic, retain) UITextField *titleTextField;
@property(nonatomic, retain) UITextField *ratingTextField;
@property(nonatomic, retain) UIButton *saveButton;

@property(nonatomic, assign) SituationActionViewMode situationMode;
@property(nonatomic, copy) NSString *introLabelText;
@property(nonatomic, assign, getter = shouldShowTableFooterView) BOOL showTableFooterView;
@property(nonatomic, assign) UITableViewCellSelectionStyle tableViewCellSelectionStyle;
@property(nonatomic, retain) NSArray *situations;

// Initializers
- (id)initWithSession:(Session *)session action:(Action *)action situationMode:(SituationActionViewMode)mode;

// UIActions
- (void)handleSaveButtonTapped:(id)sender;
- (void)handleInfoButtonTapped:(id)sender;

@end
