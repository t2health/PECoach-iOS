//
//  PECoachConstants.m
//  PECoach
//

#import "PECoachConstants.h"

#pragma mark - Action groups

NSString *const kActionGroupPlaceHolder = @"placeholder";
NSString *const kActionGroupTasks = @"tasks";
NSString *const kActionGroupRecord = @"record";
NSString *const kActionGroupToolbox = @"toolbox";
NSString *const kActionGroupHomework = @"homework";

#pragma mark - Action Types

NSString *const kActionTypeAppendSituations = @"kAppendSituationsAction";
NSString *const kActionTypeAppointments = @"kAppointmentsAction";
NSString *const kActionTypeSUDSAnchors = @"kSUDSAnchorsAction";
NSString *const kActionTypeAssessSituations = @"kAssessSituationsAction";
NSString *const kActionTypeAudioSessionPlayback = @"kAudioSessionPlaybackAction";
NSString *const kActionTypeAudioImaginalExposurePlayback = @"kAudioImaginalExposurePlaybackAction";
NSString *const kActionTypeCompareSituations = @"kCompareSituationsAction";
NSString *const kActionTypeCompleteProgram = @"kCompleteProgramAction";
NSString *const kActionTypeCreateSituations = @"kCreateSituationsAction";
NSString *const kActionTypeEditSecuritySettings = @"kEditSecuritySettingsAction";
NSString *const kActionTypeEditSituations = @"kEditSituationsAction";
NSString *const kActionTypeListScorecards = @"kListScorecardsAction";
NSString *const kActionTypeListSituations = @"kListSituationsAction";
NSString *const kActionTypeManageAudioRecordings = @"kManageAudioRecordingsAction";
NSString *const kActionTypeParent = @"kParentAction";
NSString *const kActionTypePracticeBreathing = @"kPracticeBreathingAction";
NSString *const kActionTypeQuestionnaire = @"kQuestionnaireAction";
NSString *const kActionTypeRecordSession = @"kRecordSessionAction";
NSString *const kActionTypeResetUserData = @"kResetUserDataAction";
NSString *const kActionTypeReviewHomework = @"kReviewHomeworkAction";
NSString *const kActionTypeSelectSituations = @"kSelectSituationsAction";
NSString *const kActionTypeTextVideo = @"kTextVideoAction";
NSString *const kActionTypeTherapistContactInformation = @"kTherapistContactInformationAction";
NSString *const kActionTypeWebView = @"kWebViewAction";

#pragma mark - Asset Keys

NSString *const kAssetKeyApplicationTitle = @"kApplicationTitle";
NSString *const kAssetKeyProgramCompletionText = @"kProgramCompletedText";
NSString *const kAssetKeySessionTemplate = @"kSessionTemplate";
NSString *const kAssetKeySessionTemplateSession2 = @"kSessionTemplateSession2";
NSString *const kAssetKeySessionTemplateSession2A = @"kSessionTemplateSession2A";
NSString *const kAssetKeySessionTemplateSession2B = @"kSessionTemplateSession2B";

#pragma mark - Application

NSString *const kApplicationContentPath = @"PECoachContent.xml";

#pragma mark - UI Defaults

const CGFloat kUITabBarDefaultHeight = 48.0;
const CGFloat kUITableCellDefaultHeight = 44.0;
const CGFloat kUITextFieldDefaultHeight = 31.0;
const CGFloat kUITextFieldSUDSWidth = 60.0;
const CGFloat kUIViewHorizontalInset = 20.0;
const CGFloat kUIViewHorizontalMargin = 8.0;
const CGFloat kUIViewVerticalInset = 20.0;
const CGFloat kUIViewVerticalMargin = 8.0;

const CGFloat kUIButtonDefaultHeight = 37.0;
const CGFloat kUIButtonSizeLargeWidth = 132.0;
const CGFloat kUIButtonSizeMediumWidth = 92.0;
const CGFloat kUIButtonSizeSmallWidth = 72.0;

#pragma mark - User Defaults Keys

NSString *const kUserDefaultsKeyContentVersion = @"com.vpd.pecoach.contentVersion";
NSString *const kUserDefaultsKeyEULAAcceptance = @"com.vpd.pecoach.ELUAAcceptance";
NSString *const kUserDefaultsKeyIntroductionShown = @"com.vpd.pecoach.introductionShown";
NSString *const kUserDefaultsKeyPIN = @"com.vpd.pecoach.PIN";
NSString *const kUserDefaultsKeyPrimarySecretQuestion = @"com.vpd.pecoach.primarySecretQuestion";
NSString *const kUserDefaultsKeyPrimarySecretAnswer = @"com.vpd.pecoach.primarySecretAnswer";
NSString *const kUserDefaultsKeySecondarySecretQuestion = @"com.vpd.pecoach.secondarySecretQuestion";
NSString *const kUserDefaultsKeySecondarySecretAnswer = @"com.vpd.pecoach.secondarySecretAnswer";

NSString *const kUserDefaultsKeyTherapistContactName = @"com.vpd.pecoach.therapistContactName";
NSString *const kUserDefaultsKeyTherapistContactPhone = @"com.vpd.pecoach.therapistContactPhone";
NSString *const kUserDefaultsKeyTherapistContactCell = @"com.vpd.pecoach.therapistContactCell";
NSString *const kUserDefaultsKeyTherapistContactEmail = @"com.vpd.pecoach.therapistContactEmail";

#pragma mark - SUDS Ratings

const NSInteger kMinimumSUDSRating = 0;
const NSInteger kMaximumSUDSRating = 100;


#pragma mark - PCL Scores

const NSInteger kMinimumPCLScore = 0;
const NSInteger kMaximumPCLScore = 85;

