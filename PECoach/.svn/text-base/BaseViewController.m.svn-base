//
//  BaseViewController.m
//  PECoach
//

#import "BaseViewController.h"
#import "PECoachAppDelegate.h"
#import "Librarian.h"

@implementation BaseViewController

#pragma mark - Properties

@synthesize librarian = librarian_;

#pragma mark - Lifecycle

/**
 *  initWithNibName
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self != nil) {
    // Ughh... I *hate* having to punch back through to the application delegate but I sort of painted myself
    // in too a bit of a corner here and I don't feel like making big architectural changes to allow for
    // the application delegate to pass the current librarian (or MOC) to the current action. Sorry.
    PECoachAppDelegate *appDelegate = (PECoachAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.librarian = appDelegate.librarian;
  }
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"newBackgroundImage.png"]];
  
  [super viewDidLoad];
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    //[Analytics logEvent:@"BASE VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [librarian_ release];
  
  [super dealloc];
}

@end
