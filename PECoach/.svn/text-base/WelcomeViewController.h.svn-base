//
//  WelcomeViewController.h
//  PECoach
//

#import "BaseViewController.h"

@class StartupManager;

@interface WelcomeViewController : BaseViewController {
  UIButton *actionButton;
  UIImageView *welcomeLogo;
  StartupManager *startupManager_;
}

// Properties
@property (nonatomic, retain) IBOutlet UIButton *actionButton;
@property(nonatomic, retain) StartupManager *startupManager;

// Initializers
- (id)initWithStartupManager:(StartupManager *)manager;

// IBActions
- (IBAction)handleStartButtonTapped:(id)sender;

@property (retain, nonatomic) IBOutlet UIImageView *welcomeLogo;

@end
