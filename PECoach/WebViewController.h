//
//  WebViewController.h
//  TMH Clinical Coach
//
//  Modified by Brian Doherty on 7/11/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController {
    
    UIWebView *webView;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
