//
//  AudioPlayerViewController.h
//  PECoach
//

#import "ActionViewController.h"

@class AudioControlView;

@interface AudioPlayerViewController : ActionViewController {
  AudioControlView *audioControlView_;
}

// Properties
@property (nonatomic, retain) AudioControlView *audioControlView;

@end
