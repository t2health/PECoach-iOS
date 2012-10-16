//
//  SituationsActionViewController.m
//  PECoach
//
/*
 *
 * PECoach
 *
 * Copyright © 2009-2012 United States Government as represented by
 * the Chief Information Officer of the National Center for Telehealth
 * and Technology. All Rights Reserved.
 *
 * Copyright © 2009-2012 Contributors. All Rights Reserved.
 *
 * THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
 * REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
 * COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
 * AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
 * THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
 * INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
 * REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
 * DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
 * HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
 * RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.
 *
 * Government Agency: The National Center for Telehealth and Technology
 * Government Agency Original Software Designation: PECoach001
 * Government Agency Original Software Title: PECoach
 * User Registration Requested. Please send email
 * with your contact information to: robert.kayl2@us.army.mil
 * Government Agency Point of Contact for Original Software: robert.kayl2@us.army.mil
 *
 */
#import "SituationsActionViewController.h"
#import "EditSituationActionViewController.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "Scorecard.h"
#import "Session.h"
#import "Situation.h"
#import "UILabel+PELabel.h"
#import "UIView+Positionable.h"
#import "MKInfoPanel.h"
#import "SUDSAnchors.h"
#import "Analytics.h"

#define kTitleFieldWidth 210.0
#define kTitleFieldWidth2 60

@implementation SituationsActionViewController

#pragma mark - Properties

@synthesize titleTextField = titleTextField_;
@synthesize ratingTextField = ratingTextField_;
@synthesize saveButton = saveButton_;

@synthesize situationMode = situationMode_;
@synthesize introLabelText = introLabelText_;
@synthesize showTableFooterView = showTableFooterView_;
@synthesize tableViewCellSelectionStyle = tableViewCellSelectionStyle_;
@synthesize situations = situations_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action:situationMode
 */
- (id)initWithSession:(Session *)session action:(Action *)action situationMode:(SituationActionViewMode)mode {
  self = [super initWithSession:session action:action tableStyle:UITableViewStylePlain];
  if (self != nil) {
    situationMode_ = mode;
    introLabelText_ = nil;
    showTableFooterView_ = NO;
    tableViewCellSelectionStyle_ = UITableViewCellSelectionStyleNone;
    
    self.tableView.backgroundColor = self.defaultSolidViewBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    switch (situationMode_) {
      case kSituationActionViewModeAppendSituations: {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        showTableFooterView_ = YES;
        break;
      }
      case kSituationActionViewModeCreateSituations: {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        showTableFooterView_ = YES;
        break;
      }
      case kSituationActionViewModeEditSituations: {
        introLabelText_ = [NSLocalizedString(@"Please select any one In Vivo Exposure Assignment for Homework:  (Homework items listed first in blue.)", @"") copy];
        tableViewCellSelectionStyle_ = UITableViewCellSelectionStyleBlue;
        break;
      }
      case kSituationActionViewModeListSituations: {
        break;
      }
      case kSituationActionViewModeReviewSituations: {
        break;
      }
      case kSituationActionViewModeSelectSituations: {
        introLabelText_ = [NSLocalizedString(@"Please choose one or more In Vivo Exposure Assignments from the list below:", @"") copy];
        tableViewCellSelectionStyle_ = UITableViewCellSelectionStyleBlue;
        break;
      }
    }
  }
  
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  CGFloat ratingFieldWidth = self.tableView.frame.size.width - kTitleFieldWidth - (kUIViewHorizontalMargin * 3);

  // Table header view
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0.0)];

  UILabel *introLabel = nil;
  CGFloat introLabelWidth = self.tableView.frame.size.width - (kUIViewHorizontalMargin * 2);
  
  if (self.introLabelText != nil) {
    introLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalInset, introLabelWidth, 0.0)];
    introLabel.text = self.introLabelText;
  }
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIViewHorizontalInset, kUIViewVerticalInset, kTitleFieldWidth, self.defaultTextFont.lineHeight)];
  titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:self.defaultTableCellFont.pointSize];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = NSLocalizedString(@"HIERARCHY", @"");

  [headerView addSubview:titleLabel];
    
    
  
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, ratingFieldWidth, titleLabel.frame.size.height)];
    ratingLabel.backgroundColor = titleLabel.backgroundColor;
    ratingLabel.font = titleLabel.font;
    ratingLabel.textAlignment = UITextAlignmentCenter;
    ratingLabel.textColor = titleLabel.textColor;
    
    [ratingLabel alignTopWithView:titleLabel];
    [ratingLabel positionToTheRightOfView:titleLabel margin:kUIViewHorizontalMargin];
    ratingLabel.text = NSLocalizedString(@"SUDS", @"");

    
    // 05/30/2012 Don't add SUDS for this screen for kActionTypeEditSituations 
    // Note...this is a little weird that we created it and then don't use it...
    // But the code would even be more convoluted if we didn't!
    if (situationMode_ != kSituationActionViewModeEditSituations)  {
        [headerView addSubview:ratingLabel];
        
        // Add an info button next to 'SUDS' to show the user's description of the SUDS
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
        //button.frame = CGRectMake(ratingLabel.frame.origin.x+button.frame.size.width, 
        //                          ratingLabel.frame.origin.y, button.frame.size.width, button.frame.size.height);
        // Place this in the upper right corner
        button.frame = CGRectMake(ratingLabel.frame.origin.x+ratingLabel.frame.size.width-button.frame.size.width-10, 
                                  ratingLabel.frame.origin.y-20, button.frame.size.width, button.frame.size.height);
        [button addTarget:self action:@selector(handleInfoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
    }
  
  if (introLabel != nil) {
    introLabel.backgroundColor = [UIColor clearColor];
    introLabel.font = self.defaultTextFont;
    introLabel.textColor = [UIColor grayColor];
    
    [introLabel resizeHeightAndWrapTextToFitWithinWidth:introLabel.frame.size.width];
    [headerView addSubview:introLabel];
    
    [titleLabel positionBelowView:introLabel margin:kUIViewVerticalInset];
    [ratingLabel alignTopWithView:titleLabel];
  }
  
  [ratingLabel release];
  [titleLabel release];
  [introLabel release];
  
  [headerView resizeHeightToContainSubviewsWithMargin:0.0];
  self.tableView.tableHeaderView = headerView;
  [headerView release];
  
  // Table footer view which includes the two input text fields.
  if (self.shouldShowTableFooterView == YES) {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0.0)];
    
    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, kUIViewVerticalMargin, kTitleFieldWidth, kUITextFieldDefaultHeight)];
    titleTextField.borderStyle = UITextBorderStyleRoundedRect;
    titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    titleTextField.delegate = self;
      titleTextField.returnKeyType = UIReturnKeyDone;
      
      // Accessibility (VoiceOver)
      [titleTextField setAccessibilityLabel:NSLocalizedString(@"Hierarchy", "")];
      
    [footerView addSubview:titleTextField];
    self.titleTextField = titleTextField;
      
      // 05/30/2012 Remove SUDS from this screen for kActionTypeEditSituations
      // Note...this is a little weird that we created it and then don't use it...
      // But the code would even be more convoluted if we didn't!
      if (situationMode_ != kSituationActionViewModeEditSituations) {
        UITextField *ratingTextField = [self SUDSTextFieldWithFrame:CGRectMake(0.0, 0.0, ratingFieldWidth, kUITextFieldDefaultHeight) text:@""];
        
        [ratingTextField alignTopWithView:titleTextField];
        [ratingTextField positionToTheRightOfView:titleTextField margin:kUIViewHorizontalMargin];
          
          // Accessibility (VoiceOver)
          [ratingTextField setAccessibilityLabel:NSLocalizedString(@"SUDS", "")];
          
        [footerView addSubview:ratingTextField];
        self.ratingTextField = ratingTextField;
      }

    UIButton *saveButton = [self buttonWithTitle:NSLocalizedString(@"Save", nil)];
    [saveButton addTarget:self action:@selector(handleSaveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setEnabled:NO];
    
    [saveButton centerHorizontallyInView:footerView];
    [saveButton positionBelowView:titleTextField margin:kUIViewVerticalInset];
        
    [footerView addSubview:saveButton];
    self.saveButton = saveButton;
    
    [footerView resizeHeightToContainSubviewsWithMargin:kUIViewVerticalInset];
    self.tableView.tableFooterView = footerView;

    [titleTextField release];
    [footerView release];
  }
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.titleTextField = nil;
  self.ratingTextField = nil;
  self.saveButton = nil;
  
  self.situations = nil;
  
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"SITUATIONS ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [titleTextField_ release];
  [ratingTextField_ release];
  [saveButton_ release];
  [introLabelText_ release];
  [situations_ release];
  
  [super dealloc];
}

#pragma mark - Property Accessors

/**
 *  situations
 */
- (NSArray *)situations {
  if (situations_ == nil) {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    switch (self.situationMode) {
      case kSituationActionViewModeAppendSituations: {
        // Show all the existing situations so the user can see which situations
        // already exist while they potentially add new ones.
        situations_ = [[self.librarian allSituations] retain];

        /* OLD METHOD - Deprecated Aug 26, 2011 */
        // Part of the Homework section of a Session. In this case, the user is adding 
        // new Situations to this Session. We show the existing Situations that were
        // selected for homework along with any new Situations the user creates. 
        // NSSet *homeworkAndNativeSituations = [self.session.homeworkSituations setByAddingObjectsFromSet:self.session.nativeSituations];
        // situations_ = [[homeworkAndNativeSituations sortedArrayUsingDescriptors:sortDescriptors] retain];
        break;
      }
      case kSituationActionViewModeCreateSituations: {
        // This mode appears to only be used in the second session. It's essentially a way to
        // begin populating the base set of situations. I figure we can just show all the
        // existing Situations since the default result will be that there are no existing
        // situations yet created.
        // *** I think this should only show Situations that were created in Session 2. TBD. ***
        situations_ = [[self.librarian allSituations] retain];
        break;
      }
      case kSituationActionViewModeEditSituations: {
          // Show all the situations that the user has selected as homework for this session.
          
          /* NEW METHOD - Deprecated May 30, 2012 */
        //situations_ = [[self.session.homeworkSituations sortedArrayUsingDescriptors:sortDescriptors] retain];

          /* OLD METHOD - Deprecated Aug 26, 2011 */
          /* OLD METHOD - UnDeprecated May 30, 2012 ...Glad this was saved!!!  */
        // List of Situations that the user can select to apply a scorecard to. We show the user's
        // selected homework Situations at the top, followed by any remaining native situations.
        
        // Note that a Situation could be present in both the homework set and the native set, so
        // we need to take that into account and remove any duplicates. We can't just merge the two
        // sets because then we'd loose the ordering of having the homework situations on top.
        NSArray *homeworkSituations = [self.session.homeworkSituations sortedArrayUsingDescriptors:sortDescriptors];
        NSSet *uniqueNativeSituations = [self.session.nativeSituations objectsPassingTest:^BOOL(id obj, BOOL *stop) {
          return [homeworkSituations containsObject:obj] == NO;}];
        //
        NSArray *nativeSituations = [uniqueNativeSituations sortedArrayUsingDescriptors:sortDescriptors];
        situations_ = [[homeworkSituations arrayByAddingObjectsFromArray:nativeSituations] retain];
        break;
      }
      case kSituationActionViewModeListSituations: {
        // Collect all the Situations that have been entered in to the application, regardless of Session.
        situations_ = [[self.librarian allSituations] retain];
        break;
      }
      case kSituationActionViewModeSelectSituations: {
        // Show all situations.
          // Sort them based on the SUDS rating (initial)  (UP and DOWN?)
          NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"initialSUDSRating" ascending:YES];
          NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        situations_ = [[[self.librarian allSituations ] sortedArrayUsingDescriptors:sortDescriptors ] retain];
        
        /* OLD METHOD - Deprecated Aug 26, 2011 */
        // Here we're showing the all the Situations that belong to the previous Sessions, sorted
        // by the homework Situations on top, then the Native situations. 
        // Session *previousSession = self.session.previousSession;
        
        // Special case the second session. Since there are no Situations in the first session, the user is
        // actually told to select Situations from this session... /shrug
        // NSArray *allSessions = [self.librarian allSessions];
        // if ([allSessions count] > 1) {
        //   Session *secondSession = [allSessions objectAtIndex:1];
        //   if ([self.session.rank isEqualToNumber:secondSession.rank] == YES) {
        //     previousSession = self.session;
        //   }
        // }
        
        // NSSet *homeworkAndNativeSituationsFromPreviousSession = [previousSession.homeworkSituations setByAddingObjectsFromSet:previousSession.nativeSituations];
        // situations_ = [[homeworkAndNativeSituationsFromPreviousSession sortedArrayUsingDescriptors:sortDescriptors] retain];
        break;
      }
       
      case kSituationActionViewModeReviewSituations: {
        // Show the Situations that the user appended to the previous session
        situations_ = [[self.session.previousSession.nativeSituations sortedArrayUsingDescriptors:sortDescriptors] retain];
        break;
      }
        
      default: {
        situations_ = [[NSArray alloc] init];
        break;
      }
    }
  }
  
  return situations_;
}

#pragma mark - UITableViewDataSource Methods

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    
    return [self.situations count];

}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"UITableViewCellStyleDefault";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = self.tableViewCellSelectionStyle;
    
    CGFloat ratingFieldWidth = self.tableView.frame.size.width - kTitleFieldWidth - (kUIViewHorizontalMargin * 3);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIViewHorizontalMargin, 0, kTitleFieldWidth, self.tableView.rowHeight)];
    titleLabel.tag = 100;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = self.defaultTableCellFont;
    titleLabel.textColor = self.defaultTextColor;
    
    [cell.contentView addSubview:titleLabel];
      
      // 05/30/2012 Remove SUDS from this screen for kActionTypeEditSituations 
      if (situationMode_ != kSituationActionViewModeEditSituations)  {
        UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ratingFieldWidth, self.tableView.rowHeight)];
        ratingLabel.tag = 200;
        ratingLabel.backgroundColor = titleLabel.backgroundColor;
        ratingLabel.font = self.defaultTableCellFont;
        ratingLabel.textAlignment = UITextAlignmentCenter;
        ratingLabel.textColor = self.defaultTextColor;
        
        [ratingLabel positionToTheRightOfView:titleLabel margin:kUIViewHorizontalMargin];
          
          [cell setAccessibilityLabel:ratingLabel.text];
          
        [cell.contentView addSubview:ratingLabel];

        [ratingLabel release];
      }
     
      
      // Implement Accessibility
      [cell setIsAccessibilityElement:YES];
      [cell setAccessibilityTraits:UIAccessibilityTraitButton];
      
    [titleLabel release];
  }

  [self configureCell:cell atIndexPath:indexPath withTableView:tableView];
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Situation *situation = [self.situations objectAtIndex:indexPath.row];
  
  if (self.situationMode == kSituationActionViewModeSelectSituations) {
    if ([self.session.homeworkSituations containsObject:situation] == YES) {
      [self.session removeHomeworkSituationsObject:situation];
    } else {
      [self.session addHomeworkSituationsObject:situation];
    }
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  } else if (self.situationMode == kSituationActionViewModeEditSituations) {
    EditSituationActionViewController *viewController = [[EditSituationActionViewController alloc] initWithSession:self.session action:nil];
    viewController.situation = situation;
    viewController.showDoneButton = NO;
    viewController.showHomeButton = NO;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
  }
}

#pragma mark - UITextFieldDelegate Methods

/**
 *  textField:shouldChangeCharactersInRange
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  BOOL shouldChangeCharacters = [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
  if (shouldChangeCharacters == YES) {
    NSString *proposedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableArray *strings = [[NSMutableArray alloc] initWithCapacity:2];

    if (textField == self.titleTextField) {
      [strings addObject:proposedString];
      [strings addObject:(self.ratingTextField.text != nil ? self.ratingTextField.text : @"")];
    } else if (textField == self.ratingTextField) {
      [strings addObject:(self.titleTextField.text != nil ? self.titleTextField.text : @"")];
      [strings addObject:proposedString];
    }
    
    __block BOOL enableSaveButton = YES;
    [strings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      NSString *textFieldText = (NSString *)obj;
      enableSaveButton = [textFieldText length] > 0;
      *stop = !enableSaveButton;
    }];
    
    self.saveButton.enabled = enableSaveButton;
    [strings release];
  }
  
  return shouldChangeCharacters;
}

#pragma mark - UI Actions

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
  if ([self isValidSUDSRating:self.ratingTextField.text] == NO) {
    [[self alertViewForInvalidSUDSRating] show];
    return;
  }
  
  if ([self.titleTextField.text length] < 1) {
    NSString *alertTitle = NSLocalizedString(@"Alert", @"");
    NSString *alertMessage = NSLocalizedString(@"All hierarchies need to have a valid name.", @"");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                    message:alertMessage 
                                                   delegate:nil 
                                          cancelButtonTitle:NSLocalizedString(@"Continue", @"") 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
  }
  
  NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:self.titleTextField.text, @"title", 
                                                                    [NSNumber numberWithInteger:[self.ratingTextField.text integerValue]], @"initialSUDSRating", 
                                                                    [NSDate date], @"creationDate", nil];

  Situation *situation = [self.librarian insertNewSituationWithValues:values];
  situation.nativeSession = self.session;
    
  self.titleTextField.text = nil;
  self.ratingTextField.text = nil;

  [self.titleTextField becomeFirstResponder];
  self.saveButton.enabled = NO;
  
  // Need to reload the table data since we've likely changed the situations_ array. 
  self.situations = nil;
  [self.tableView reloadData];
  [self.tableView scrollRectToVisible:self.tableView.tableFooterView.frame animated:YES];
}



/**
 *  handleInfoButtonTapped
 */
- (void)handleInfoButtonTapped:(id)sender {
    
    SUDSAnchors *sudsAnchors = [SUDSAnchors alloc];
    sudsAnchors.pListFileName = [NSString stringWithFormat:@"SUDSAnchors"];
    [sudsAnchors initPlist];
    [MKInfoPanel showPanelInView:self.view 
                            type:MKInfoPanelTypeInfo 
                           title:@"SUDS SITUATION DESCRIPTIONS" 
                        subtitle:[sudsAnchors stringSUDSAnchors] 
                       hideAfter:15
                        width:255 height:200];
    
    [sudsAnchors release];
    
}


#pragma mark - UIKeyboard Notification Handlers

/**
 *  handleKeyboardDidShowNotification
 */
- (void)handleKeyboardDidShowNotification:(NSNotification *)notification {
  CGRect bounds = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  CGRect tableFrame = self.tableView.frame;
  
  // Subtract the height of the keyboard and the fixed height of the tab bar
  tableFrame.size.height = tableFrame.size.height - (bounds.size.height - kUITabBarDefaultHeight);
  self.tableView.frame = tableFrame;
  
  [self.tableView scrollRectToVisible:self.tableView.tableFooterView.frame animated:YES];
}

/**
 *  handleKeyboardWillHideNotification
 */
- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
  CGRect bounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGRect tableFrame = self.tableView.frame;

  // Add the height of the keyboard and the fixed height of the tab bar
  tableFrame.size.height = tableFrame.size.height + (bounds.size.height - kUITabBarDefaultHeight);  
  self.tableView.frame = tableFrame;

  [self.tableView scrollRectToVisible:self.tableView.tableFooterView.frame animated:YES];
}

#pragma mark - Instance Methods

/**
 *  configureCell:atIndexPath:withTableView
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
  Situation *situation = [self.situations objectAtIndex:indexPath.row];
  BOOL situationIsHomework = [self.session.homeworkSituations containsObject:situation];
  
  UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
  titleLabel.text = situation.title;

  UILabel *rankingLabel = (UILabel *)[cell viewWithTag:200];
  rankingLabel.text = [situation.initialSUDSRating stringValue];

  // Set the cell's accessory based on our view mode.
  if (self.situationMode == kSituationActionViewModeSelectSituations && situationIsHomework == YES) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else if (self.situationMode == kSituationActionViewModeEditSituations) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  // Set the text label text color.
  if (situationIsHomework == YES && 
      (self.situationMode == kSituationActionViewModeSelectSituations || self.situationMode == kSituationActionViewModeEditSituations)) {
    titleLabel.textColor = self.session.color;
      //titleLabel.backgroundColor = [UIColor grayColor];
    rankingLabel.textColor = titleLabel.textColor;
  } else {
    titleLabel.textColor = self.defaultTextColor;
    rankingLabel.textColor = self.defaultTextColor;
  }
    
}

@end