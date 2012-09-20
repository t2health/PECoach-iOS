//
//  SUDSAnchorViewController.m
//  PECoach
//
//  Created by Brian Doherty on 5/31/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import "SUDSAnchorViewController.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "Scorecard.h"
#import "Session.h"
#import "Situation.h"
#import "UILabel+PELabel.h"
#import "UIView+Positionable.h"
#import "SUDSTextField.h"
#import "Analytics.h"
#import <QuartzCore/QuartzCore.h>

@interface SUDSAnchorViewController ()

@end

@implementation SUDSAnchorViewController
@synthesize sudsAnchors;

#pragma mark - Lifecycle

/**
 *  initWithSession:action:situationMode
 */
- (id)initWithSession:(Session *)session action:(Action *)action  {
    self = [super initWithSession:session action:action];
    if (self != nil) {    
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    // Create a backdrop for our label...a quick workaround for 'inset' instead of subclassing UILABEL
    UILabel *backlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 320, 70)];
    backlabel1.backgroundColor = [UIColor whiteColor];
    backlabel1.font = [UIFont boldSystemFontOfSize:self.defaultTableCellFont.pointSize];
    backlabel1.textColor = [UIColor grayColor];
    backlabel1.layer.cornerRadius = 8;;
    [self.view addSubview:backlabel1];
    [backlabel1 release];
    
    // Tell the user what this screen is for
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 260, 70)];
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:self.defaultTableCellFont.pointSize];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.layer.cornerRadius = 8;
    titleLabel.text = [NSLocalizedString(@"To make the SUDS scale fit you, your therapist will ask you what situations represent different levels on the scale.", @"") copy];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    // Create a backdrop for the SUDS value-situation
    UILabel *backlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 320, 245)];
    backlabel2.backgroundColor = [UIColor whiteColor];
    backlabel2.font = [UIFont boldSystemFontOfSize:self.defaultTableCellFont.pointSize];
    backlabel2.textColor = [UIColor grayColor];
    backlabel2.layer.cornerRadius = 8;;
    [self.view addSubview:backlabel2];
    [backlabel2 release];
    
    // Create the header
    UILabel *sudsDesclabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 50, 25)];
    sudsDesclabel.backgroundColor = [UIColor whiteColor];
    sudsDesclabel.font = [UIFont boldSystemFontOfSize:self.defaultTableCellFont.pointSize];
    sudsDesclabel.textColor = [UIColor blackColor];
    sudsDesclabel.layer.cornerRadius = 8;;
    sudsDesclabel.text = [NSLocalizedString(@"SUDS", @"") copy];
    [self.view addSubview:sudsDesclabel];
    [sudsDesclabel release];
    
    UILabel *sitlabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 120, 200, 25)];
    sitlabel.backgroundColor = [UIColor whiteColor];
    sitlabel.font = [UIFont boldSystemFontOfSize:self.defaultTableCellFont.pointSize];
    sitlabel.textColor = [UIColor blackColor];
    sitlabel.layer.cornerRadius = 8;;
    sitlabel.text = [NSLocalizedString(@"SITUATION DESCRIPTION", @"") copy];
    [self.view addSubview:sitlabel];
    [sitlabel release];
    
    // Get the current values of the SUDS value/description pairs
    sudsAnchors = [SUDSAnchors alloc];
    sudsAnchors.pListFileName = [NSString stringWithFormat:@"SUDSAnchors"];
    [sudsAnchors initPlist];
    
    // Add the text fields for the user to enter the Situation Description
    for (int i=0;i<5;i++) {
              
        UILabel *sudslabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 155+35*i, 40, 25)];
        sudslabel.backgroundColor = [UIColor whiteColor];
        sudslabel.font = [UIFont boldSystemFontOfSize:self.defaultTableCellFont.pointSize];
        sudslabel.textColor = [UIColor blueColor];
        sudslabel.layer.cornerRadius = 8;;
        sudslabel.text = [sudsAnchors valueForIndex:i];
        [self.view addSubview:sudslabel];
        [sudslabel release];
        
                                                                    // Note we increment Y by 35*i
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(70, 150+35*i, 230, 30)];
        textfield.borderStyle = UITextBorderStyleRoundedRect;
        textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textfield.tag = i;              // Set the tag to the index (for later update, etc)
        textfield.delegate = self;
        textfield.returnKeyType = UIReturnKeyDone;
        textfield.text = [sudsAnchors descForIndex:i];                
        
        [self.view addSubview:textfield];
        [textfield release];
    }
    
    // Write a summary message
    UILabel *sudslabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 145+35*5, 280, 45)];
    sudslabel.backgroundColor = [UIColor whiteColor];
    sudslabel.font = [UIFont systemFontOfSize:self.defaultTableCellFont.pointSize];
    sudslabel.textColor = [UIColor blueColor];
    sudslabel.textAlignment = UITextAlignmentCenter;
    sudslabel.numberOfLines = 0;
    sudslabel.layer.cornerRadius = 8;;
    sudslabel.text = [NSLocalizedString(@"These descriptions can always be found in the Toolbox section of this App", @"") copy];
    [self.view addSubview:sudslabel];
    [sudslabel release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - UITextFieldDelegate Methods

/**
 *  textFieldDidBeginEditing
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextField:textField up:YES];
}

/**
 *  textFieldDidEndEditing
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField:textField up:NO];
    
    // Grab the change, store it back in our array and write it back to the file
    int myIndex = textField.tag;
    [sudsAnchors descForIndex:myIndex desc:textField.text];
    
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int animatedDistance;
    //int origin = self.view.frame.origin.y;
    int origin = 70;                 // Place holder....need to figure this out dynamiclly in the code
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height+origin;
    
    // UGH....There is an iOS bug getting the keyboard height
    // ...textFieldDidBeginEditing which calls us, is called before keyBoardWillShow which gets the keyboardheight
    // So once we go through the cycle, we have the keyboard height, but we can't get it the first time through!
    // I'll come back to this with a timer or something, but for now...here goes a kluge...
    if (keyBoardHeight == 0) keyBoardHeight = 216;
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        animatedDistance = keyBoardHeight-(480-moveUpValue-5);
    }
    else
    {
        animatedDistance = keyBoardHeight-(320-moveUpValue-5);
    }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f; 
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);       
        [UIView commitAnimations];
    }
}
/**
 *  textFieldShouldReturn
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/**
 *  textField:shouldChangeCharactersInRange
 */
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"SUDSAnchorView:  textFieldShouldChangeCharactersInRange");
    if ([textField isKindOfClass:[SUDSTextField class]] == YES) {
        NSString *proposedString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
        if ([proposedString length] > 0 && [self isValidSUDSRating:proposedString] == NO) {
            UIAlertView *alertView = [self alertViewForInvalidSUDSRating];
            [alertView show];
            
            return NO;
        }
    }
    
    return YES;
}
*/
#pragma mark - UIKeyboard Notification Methods

/**
 *  handleKeyboardDidShowNotification
 */
- (void)handleKeyboardDidShowNotification:(NSNotification*)notification {
}

/**
 *  handleKeyboardWillHideNotification
 */
- (void)handleKeyboardWillHideNotification:(NSNotification*)notification {
}

/**
 *  handleKeyboardWillShowNotification
 */
- (void)keyboardWillShow:(NSNotification *)aNotification 
{
    // Our purpose is to get the keyboard height...
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            keyBoardHeight = keyboardBounds.size.height;
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            keyBoardHeight = keyboardBounds.size.width;
            break;
    }
    
}

#pragma mark - UI Actions

/**
 *  handleSaveButtonTapped
 */
- (void)handleSaveButtonTapped:(id)sender {
    
    /*
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
     */
}

@end
