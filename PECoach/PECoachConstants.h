//
//  PECoachConstants.h
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
#import <Foundation/Foundation.h>

// Action Groups
extern NSString *const kActionGroupPlaceHolder;
extern NSString *const kActionGroupTasks;
extern NSString *const kActionGroupRecord;
extern NSString *const kActionGroupToolbox;
extern NSString *const kActionGroupHomework;

// Action Types
extern NSString *const kActionTypeAppendSituations;
extern NSString *const kActionTypeAppointments;
extern NSString *const kActionTypeSUDSAnchors;
extern NSString *const kActionTypeAssessSituations;
extern NSString *const kActionTypeAudioSessionPlayback;
extern NSString *const kActionTypeAudioImaginalExposurePlayback;
extern NSString *const kActionTypeCompareSituations;
extern NSString *const kActionTypeCompleteProgram;
extern NSString *const kActionTypeCreateSituations;
extern NSString *const kActionTypeEditSecuritySettings;
extern NSString *const kActionTypeEditSituations;
extern NSString *const kActionTypeListScorecards;
extern NSString *const kActionTypeListSituations;
extern NSString *const kActionTypeManageAudioRecordings;
extern NSString *const kActionTypeParent;
extern NSString *const kActionTypePracticeBreathing;
extern NSString *const kActionTypeQuestionnaire;
extern NSString *const kActionTypeRecordSession;
extern NSString *const kActionTypeResetUserData;
extern NSString *const kActionTypeReviewHomework;
extern NSString *const kActionTypeSelectSituations;
extern NSString *const kActionTypeTextVideo;
extern NSString *const kActionTypeTherapistContactInformation;
extern NSString *const kActionTypeWebView;

// Application Constants
extern NSString *const kApplicationContentPath;

// Asset Keys
extern NSString *const kAssetKeyApplicationTitle;
extern NSString *const kAssetKeyProgramCompletionText;
extern NSString *const kAssetKeySessionTemplate;
extern NSString *const kAssetKeySessionTemplateSession2;
extern NSString *const kAssetKeySessionTemplateSession2A;
extern NSString *const kAssetKeySessionTemplateSession2B;

// UI Defaults
extern const CGFloat kUITabBarDefaultHeight;
extern const CGFloat kUITableCellDefaultHeight;
extern const CGFloat kUITextFieldDefaultHeight;
extern const CGFloat kUITextFieldSUDSWidth;
extern const CGFloat kUIViewHorizontalInset;
extern const CGFloat kUIViewHorizontalMargin;
extern const CGFloat kUIViewVerticalInset;
extern const CGFloat kUIViewVerticalMargin;

extern const CGFloat kUIButtonDefaultHeight;
extern const CGFloat kUIButtonSizeLargeWidth;
extern const CGFloat kUIButtonSizeMediumWidth;
extern const CGFloat kUIButtonSizeSmallWidth;

// User Defaults Keys
extern NSString *const kUserDefaultsKeyContentVersion;
extern NSString *const kUserDefaultsKeyEULAAcceptance;
extern NSString *const kUserDefaultsKeyIntroductionShown;
extern NSString *const kUserDefaultsKeyPIN;
extern NSString *const kUserDefaultsKeyPrimarySecretQuestion;
extern NSString *const kUserDefaultsKeyPrimarySecretAnswer;
extern NSString *const kUserDefaultsKeySecondarySecretQuestion;
extern NSString *const kUserDefaultsKeySecondarySecretAnswer;

extern NSString *const kUserDefaultsKeyTherapistContactName;
extern NSString *const kUserDefaultsKeyTherapistContactPhone;
extern NSString *const kUserDefaultsKeyTherapistContactCell;
extern NSString *const kUserDefaultsKeyTherapistContactEmail;

// SUDS Ratings
extern const NSInteger kMinimumSUDSRating;
extern const NSInteger kMaximumSUDSRating;

// PCL Scores
extern const NSInteger kMinimumPCLScore;
extern const NSInteger kMaximumPCLScore;
