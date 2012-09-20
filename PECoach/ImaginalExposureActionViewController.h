//
//  ImaginalExposureActionViewController.h
//  PECoach
//

#import "FormActionViewController.h"

@class AudioControlView;

typedef enum {
    kImaginalExposureActionViewStateEnterPreSUDS = 1,
    kImaginalExposureActionViewStatePlayRecording,
    kImaginalExposureActionViewStateEnterPostSUDS,
    kImaginalExposureActionViewStateEnterCompleted
} ImaginalExposureActionViewState;

@interface ImaginalExposureActionViewController : FormActionViewController {
    UILabel *instructionsLabel_;
    UIView *ratingsView_;
    UILabel *preSUDSLabel_;
    UILabel *postSUDSLabel_;
    UILabel *peakSUDSLabel_;
    UITextField *preSUDSTextField_;
    UITextField *postSUDSTextField_;
    UITextField *peakSUDSTextField_;
    AudioControlView *audioControlView_;
    ImaginalExposureActionViewState state_;
    NSTimer *audioHackTimer_;
    
    NSString *imaginalFilePathStart_;
    NSString *imaginalFilePathEnd_;
    
    BOOL bImaginalFileExists_;
}

// Properties
@property(nonatomic, retain) UILabel *instructionsLabel;
@property(nonatomic, retain) UIView *ratingsView;
@property(nonatomic, retain) UILabel *preSUDSLabel;
@property(nonatomic, retain) UILabel *postSUDSLabel;
@property(nonatomic, retain) UILabel *peakSUDSLabel;
@property(nonatomic, retain) UITextField *preSUDSTextField;
@property(nonatomic, retain) UITextField *postSUDSTextField;
@property(nonatomic, retain) UITextField *peakSUDSTextField;
@property(nonatomic, retain) AudioControlView *audioControlView;
@property(nonatomic, assign) ImaginalExposureActionViewState state;
@property(nonatomic, assign) NSTimer *audioHackTimer;
@property(nonatomic, retain) NSString *imaginalFilePathStart;
@property(nonatomic, retain) NSString *imaginalFilePathEnd;
@property(nonatomic, assign) BOOL bImaginalFileExists;

// Event Handlers
- (void)audioHackTimerDidFire:(NSTimer *)time;

@end
