//
//  ManageRecordingsActionViewController.m
//  PECoach
//

#import "ManageRecordingsActionViewController.h"
#import "Librarian.h"
#import "Recording.h"
#import "Session.h"
#import "Analytics.h"

@implementation ManageRecordingsActionViewController

#pragma mark - Properties

@synthesize sessionsWithRecordings = sessionsWithRecordings_;

#pragma mark - Lifecycle

/**
 *  initWithNibName
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self != nil) {
  }
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.tableView setEditing:YES];
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.sessionsWithRecordings = nil;
  
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"MANAGE RECORDINGS ACTION VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [sessionsWithRecordings_ release];
  
  [super dealloc];
}

#pragma mark - Property Accessors

/**
 *  sessionsWithRecordings
 */
- (NSArray *)sessionsWithRecordings {
  if (sessionsWithRecordings_ == nil) {
    NSArray *allSessions = [self.librarian allSessions];
    NSMutableArray *sessions = [[NSMutableArray alloc] initWithCapacity:[allSessions count]];
    
    [allSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      Session *session = (Session *)obj;
      if (session.recording != nil) {
        [sessions addObject:session];
      }
    }];
    
    sessionsWithRecordings_ = [sessions copy];
    [sessions release];
  }
  
  return sessionsWithRecordings_;
}

#pragma mark - UITableViewDataSource Methods

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.sessionsWithRecordings count];
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"UITableViewCellStyleDefault";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = self.defaultTableCellFont;
    cell.textLabel.textColor = self.defaultTextColor;
  }

  Session *session = [self.sessionsWithRecordings objectAtIndex:indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", session.title, NSLocalizedString(@"Recording", nil)];
    
    // Implement Accessibility
    [cell setIsAccessibilityElement:YES];
    [cell setAccessibilityTraits:UIAccessibilityTraitButton];
    [cell setAccessibilityLabel:cell.textLabel.text];
    
  
  return cell;
}

/**
 *  tableView:commitEditingStyle:forRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Session *session = [self.sessionsWithRecordings objectAtIndex:indexPath.row];

    if (session == self.session) {
      [self stopSessionRecording];
    }
    
    [self.librarian deleteObject:session.recording];
    [self.librarian save];
      
      // Look for any additional recordings for this session
      NSFileManager *fileManager = [[NSFileManager alloc] init];
      NSString *applicationDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
      
      // We are just looking for audio files that belong to this session
      NSString *filePrefix = [NSString stringWithFormat:@"%@ Recording", self.session.title];
      NSError *error = nil;
      for (NSString *filename in [fileManager contentsOfDirectoryAtPath:applicationDocumentsPath error:&error]) {
          // Only delete files with our filePrefix
          NSRange prefixRange = [filename rangeOfString:filePrefix];
          if (prefixRange.location != NSNotFound)
          {
              // Delete it
              [fileManager removeItemAtPath:[applicationDocumentsPath stringByAppendingPathComponent:filename] error:&error];
          }
      } 
      
    self.sessionsWithRecordings = nil;
    [tableView reloadData];
  }
}


#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Let's track what the user really clicked on
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *rowTitle = newCell.textLabel.text;
    [Analytics logEvent:[NSString stringWithFormat:@"TABLE: %@, SELECTION: %@",self.title, rowTitle]];
}

@end
