//
//  WebViewController.m
//  TMH Clinical Coach
//
//  Modified by Brian Doherty on 7/11/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "WebViewController.h"
#import "Analytics.h"


@implementation WebViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [webView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Clinician's Guide.
    NSURL *url = [NSURL URLWithString:@"http://t2health.org/sites/default/files/mobile_apps/pe-coach/PE-Coach_Clinical-Guidelines_iOS_02.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [Analytics logEvent:@"WEB VIEW"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
