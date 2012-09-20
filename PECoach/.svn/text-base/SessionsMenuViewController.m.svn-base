//
//  SessionsMenuViewController.m
//  PECoach
//

#import "SessionsMenuViewController.h"
#import "Action.h"
#import "Asset.h"
#import "ContentLoader.h"
#import "Librarian.h"
#import "PECoachConstants.h"
#import "PECoachAppDelegate.h"
#import "Session.h"
#import "Analytics.h"
#import "Visit.h"

@implementation SessionsMenuViewController

#pragma mark - Properties

@synthesize librarian = librarian_;
@synthesize delegate = delegate_;

#pragma mark - Lifecycle

/**
 *  initWithLibrarian
 */
- (id)initWithLibrarian:(Librarian *)librarian {
  self = [super initWithNibName:@"SessionsMenuViewController" bundle:nil];
  if (self != nil) {
    librarian_ = [librarian retain];
  }
  
  return self;
}



/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = self.librarian.applicationTitle;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *actionBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add Session", nil) 
                                                                            style:UIBarButtonItemStyleBordered 
                                                                           target:self 
                                                                           action:@selector(handleAddButtonTapped:)];  
  
    // Highlight the Add Session button....only works on iOS 5.0 and later!
    if ([actionBarButtonItem respondsToSelector:@selector(tintColor)]) 
            actionBarButtonItem.tintColor = [UIColor orangeColor];
    
  self.navigationItem.rightBarButtonItem = actionBarButtonItem;
  [actionBarButtonItem release];
    
    // If we are timing homework, write out the time now
    // The user pressed the Switch Session button and bypassed normal processing!
    PECoachAppDelegate *appDelegate = (PECoachAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.doingHomework == YES) {
        NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:appDelegate.startVisitDate, @"startDate", [NSDate date], @"endDate", nil];
        Visit *visit = [self.librarian insertNewVisitWithValues:values];
        visit.action = appDelegate.actionHomework;              //   self.action;
        
        appDelegate.actionHomework.completed = [NSNumber numberWithBool:YES];
        [self.librarian save];
        
        // Not doing homework again until the user selects an assignment
        appDelegate.doingHomework = NO;

    }

  
    
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:[NSString stringWithFormat:@"SESSIONS MENU VIEW: %@",self.navigationItem.title]];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [librarian_ release];
  
  [super dealloc];
}

#pragma mark - UITableViewDataSource Methods

/**
 *  numberOfSectionsInTableView
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *sessions = [self.librarian allSessions];
  return [sessions count];
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"UITableViewCellStyleDefault";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.25 alpha:1.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    UIImageView *cellBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainMenuTableCellBackground.png"]]; 
    cell.backgroundView = cellBackgroundImageView;
    [cellBackgroundImageView release];
  }

  // Configure the cell...
  NSArray *sessions = [self.librarian allSessions];
  Session *session = [sessions objectAtIndex:indexPath.row];
  cell.textLabel.text = session.title;
  cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Large", session.icon]];
    
  // Implement Accessibility
    [cell setIsAccessibilityElement:YES];
    [cell setAccessibilityTraits:UIAccessibilityTraitButton];
    [cell setAccessibilityLabel:cell.textLabel.text];
    
  
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:heightForRowAtIndexPath
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 85.0;
}

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *sessions = [self.librarian allSessions];
  Session *session = [sessions objectAtIndex:indexPath.row];
    
    
    if ([[session actionsForGroup:kActionGroupPlaceHolder] count] > 0) {
        NSString *alertTitle = NSLocalizedString(@"SESSION 2 - Setup", @"");
        NSString *alertMessage = NSLocalizedString(@"Ask your clinician if you are completing all of Session 2 (One Part) or splitting Session 2 into Two Parts.", @"");
        NSString *oneTitle = NSLocalizedString(@"ONE PART", @"");
        NSString *twoTitle = NSLocalizedString(@"TWO PARTS", @"");
        NSString *quitTitle = NSLocalizedString(@"CANCEL", @"");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                            message:alertMessage 
                                                           delegate:self 
                                                  cancelButtonTitle:nil 
                                                  otherButtonTitles:oneTitle, twoTitle, quitTitle, nil];
        [alertView show];
        [alertView release];
        
        //return;
    } else {
        
        if ([self.delegate respondsToSelector:@selector(sessionsMenuViewController:didSelectSession:)] == YES) {
            [self.delegate sessionsMenuViewController:self didSelectSession:session];
        }
    }
   
    
    // Let's track what the user really clicked on
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *rowTitle = newCell.textLabel.text;
    [Analytics logEvent:[NSString stringWithFormat:@"TABLE: %@, SELECTION: %@",self.title, rowTitle]];
    
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UIAlertViewDelegate Methods

/**
 *  alertView:clickedButtonAtIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    ContentLoader *contentLoader = [[ContentLoader alloc] initWithLibrarian:self.librarian];
    // buttonIndex 0 is a Single Session 2 session
    // buttonIndex 1 is the Double Session 2 sessions.
    switch (buttonIndex) {
        case 0:
            [Analytics logEvent:@"CREATE ONE PART SESSION 2"];
            [contentLoader loadSessionFromTemplate:kAssetKeySessionTemplateSession2];
            break;
            
        case 1:
            [Analytics logEvent:@"CREATE TWO PART SESSION 2"];
            [contentLoader loadSessionFromTemplate:kAssetKeySessionTemplateSession2B];
            [contentLoader loadSessionFromTemplate:kAssetKeySessionTemplateSession2A];
            break;
            
        case 2:    
        default:
            break;
    } 
    
    [contentLoader release];
    
    [self.tableView reloadData];
}

#pragma mark - UI Actions

/**
 *  handleAddButtonTapped
 */
- (void)handleAddButtonTapped:(id)sender {
  [Analytics logEvent:@"ADD SESSION"];
  ContentLoader *contentLoader = [[ContentLoader alloc] initWithLibrarian:self.librarian];
    [contentLoader loadSessionFromTemplate:kAssetKeySessionTemplate];
  [contentLoader release];

  [self.tableView reloadData];
}

@end
