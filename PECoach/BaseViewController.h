//
//  BaseViewController.h
//  PECoach
//

#import <UIKit/UIKit.h>

@class Librarian;

@interface BaseViewController : UIViewController {
  Librarian *librarian_;
}

// Properties
@property(nonatomic, retain) Librarian *librarian;

@end
