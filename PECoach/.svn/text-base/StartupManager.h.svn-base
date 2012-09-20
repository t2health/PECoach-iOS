//
//  StartupManager.h
//  PECoach
//

#import <Foundation/Foundation.h>

@interface StartupManager : NSObject {
  BOOL agreedToEULA_;
  BOOL seenIntroduction_;
  BOOL authenticated_;
  NSString *PIN_;
  NSString *primarySecretQuestion_;
  NSString *primarySecretAnswer_;
  NSString *secondarySecretQuestion_;
  NSString *secondarySecretAnswer_;
}

// Properties
@property(nonatomic, assign, getter = hasAgreedToEULA) BOOL agreedToEULA;
@property(nonatomic, assign, getter = hasSeenIntroduction) BOOL seenIntroduction;
@property(nonatomic, assign, getter = isAuthenticated) BOOL authenticated;
@property(nonatomic, copy) NSString *PIN;

@property(nonatomic, copy) NSString *primarySecretQuestion;
@property(nonatomic, copy) NSString *primarySecretAnswer;
@property(nonatomic, copy) NSString *secondarySecretQuestion;
@property(nonatomic, copy) NSString *secondarySecretAnswer;

// Initializers
- (id)init;

// Instance Methods
- (void)authenticateWithPIN:(NSString *)PIN;
- (NSString *)recoverPINWithPrimaryAnswer:(NSString *)primaryAnswer secondaryAnswer:(NSString *)secondaryAnswer;

- (void)restore;
- (void)save;
- (void)reset;

@end
