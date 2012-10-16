//
//  ActionTableViewController.m
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
#import "ActionTableViewController.h"
#import "Action.h"
#import "Session.h"

#import "Analytics.h"

@implementation ActionTableViewController

#pragma mark - Properties

@synthesize tableView = tableView_;
@synthesize tableViewStyle = tableViewStyle_;

#pragma mark - Lifecycle

/**
 *  initWithSession:action:tableStyle
 */
- (id)initWithSession:(Session *)session action:(Action *)action tableStyle:(UITableViewStyle)tableStyle {
  self = [super initWithSession:session action:action];
  if (self != nil) {
    tableViewStyle_ = tableStyle;
  }
  return self;
}

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  CGRect tableFrame = self.view.frame;
  tableFrame.size.height -= self.infoView.frame.size.height;
  tableFrame.origin.y = self.infoView.frame.origin.y + self.infoView.frame.size.height;
  
  UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame style:self.tableViewStyle];
  tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  tableView.dataSource = self;
  tableView.delegate = self;
  
  if (self.tableViewStyle == UITableViewStyleGrouped) {
    tableView.backgroundColor = [UIColor clearColor];
  }
  
  [self.view addSubview:tableView];
  self.tableView = tableView;
  [tableView release];
  
}

/**
 *  viewDidUnload
 */
- (void)viewDidUnload {
  self.tableView.delegate = nil;
  self.tableView = nil;
  
  [super viewDidUnload];
}

/**
 *  viewDidAppear
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if ([self.tableView indexPathForSelectedRow] != nil) {
    // Force reload the row since we've likely changed the "Visited" status of it.
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.tableView indexPathForSelectedRow]] withRowAnimation:UITableViewRowAnimationNone];
    
    // Force reload above breaks the animation here.... /sigh
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]  animated:YES];
  }
}

- (void)viewDidAppear:(BOOL)animated {
    //[Analytics logEvent:@"ACTION TABLE VIEW"];
    [super viewDidAppear:animated];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [tableView_ setDelegate:nil];
  [tableView_ release];
  
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
  return 0;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"UITableViewCellStyleDefault";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }

  // Configure the cell...
    
    // Implement Accessibility
    [cell setIsAccessibilityElement:YES];
    [cell setAccessibilityLabel:cell.textLabel.text];
    [cell setAccessibilityTraits:UIAccessibilityTraitButton];
    
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:heightForRowAtIndexPath
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return tableView.rowHeight;
}

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Default no-op.
    // But let's track what the user really clicked on
    //UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    //NSString *rowTitle = newCell.textLabel.text;
    //[Analytics logEvent:[NSString stringWithFormat:@"TABLE: %@, SELECTION: %@",self.title, rowTitle]];
    
}

#pragma mark - Instance Methods

/**
 *  configureCell:atIndexPath:withTableView
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
  // Default no-op.
}

@end

