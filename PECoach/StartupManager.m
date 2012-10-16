//
//  StartupManager.m
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
#import "StartupManager.h"
#import "PECoachConstants.h"

@implementation StartupManager

#pragma mark - Properties

@synthesize agreedToEULA = agreedToEULA_;
@synthesize seenIntroduction = seenIntroduction_;
@synthesize authenticated = authenticated_;
@synthesize PIN = PIN_;
@synthesize primarySecretQuestion = primarySecretQuestion_;
@synthesize primarySecretAnswer = primarySecretAnswer_;
@synthesize secondarySecretQuestion = secondarySecretQuestion_;
@synthesize secondarySecretAnswer = secondarySecretAnswer_;

#pragma mark - Lifecycle

/**
 *  init
 */
- (id)init {
  self = [super init];
  if (self != nil) {
    [self restore];
  }
  
  return self;
}


/**
 *  dealloc
 */
- (void)dealloc {
  [PIN_ release];
  [primarySecretQuestion_ release];
  [primarySecretAnswer_ release];
  [secondarySecretQuestion_ release];
  [secondarySecretAnswer_ release];
  
  [super dealloc];
}

#pragma mark - Property Accessors

/**
 *  isAuthenticated
 */
- (BOOL)isAuthenticated {
  // If the user hasn't set a PIN, then we consider them authenticated.
  // Note that if PIN is nil, this will still return '0'.
  if ([self.PIN length] == 0) {
    return YES;
  }
  
  return authenticated_;
}

#pragma mark - Instance Methods

/**
 *  authenticateWithPIN
 */
- (void)authenticateWithPIN:(NSString *)PIN {
  self.authenticated = [self.PIN isEqualToString:PIN];
}

/**
 *  recoverPINWithPrimaryAnswer:secondaryAnswer
 */

- (NSString *)recoverPINWithPrimaryAnswer:(NSString *)primaryAnswer secondaryAnswer:(NSString *)secondaryAnswer {
  if ([[self.primarySecretAnswer uppercaseString] isEqualToString:[primaryAnswer uppercaseString]] && 
      [[self.secondarySecretAnswer uppercaseString] isEqualToString:[secondaryAnswer uppercaseString]]) {
    return self.PIN;
  }
  
  return nil;
}

/**
 *  restore
 */
- (void)restore {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
  self.agreedToEULA = [defaults boolForKey:kUserDefaultsKeyEULAAcceptance];
  self.seenIntroduction = [defaults boolForKey:kUserDefaultsKeyIntroductionShown];
  self.PIN = [defaults objectForKey:kUserDefaultsKeyPIN];
  self.primarySecretQuestion = [defaults objectForKey:kUserDefaultsKeyPrimarySecretQuestion];
  self.primarySecretAnswer = [defaults objectForKey:kUserDefaultsKeyPrimarySecretAnswer];
  self.secondarySecretQuestion = [defaults objectForKey:kUserDefaultsKeySecondarySecretQuestion];
  self.secondarySecretAnswer = [defaults objectForKey:kUserDefaultsKeySecondarySecretAnswer];

  self.authenticated = NO;
}

/**
 *  save
 */
- (void)save {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  [defaults setBool:self.hasAgreedToEULA forKey:kUserDefaultsKeyEULAAcceptance];
  [defaults setBool:self.hasSeenIntroduction forKey:kUserDefaultsKeyIntroductionShown];
  [defaults setObject:self.PIN forKey:kUserDefaultsKeyPIN];
  [defaults setObject:self.primarySecretQuestion forKey:kUserDefaultsKeyPrimarySecretQuestion];
  [defaults setObject:self.primarySecretAnswer forKey:kUserDefaultsKeyPrimarySecretAnswer];
  [defaults setObject:self.secondarySecretQuestion forKey:kUserDefaultsKeySecondarySecretQuestion];
  [defaults setObject:self.secondarySecretAnswer forKey:kUserDefaultsKeySecondarySecretAnswer];
  
  [defaults synchronize];
}

/**
 *  reset
 */
- (void)reset {
  self.agreedToEULA = NO;
  self.seenIntroduction = NO;
  self.PIN = nil;
  self.primarySecretAnswer = nil;
  self.primarySecretAnswer = nil;
  self.secondarySecretQuestion = nil;
  self.secondarySecretAnswer = nil;

  [self save];
}

@end
