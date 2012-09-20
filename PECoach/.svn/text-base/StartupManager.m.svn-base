//
//  StartupManager.m
//  PECoach
//

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
