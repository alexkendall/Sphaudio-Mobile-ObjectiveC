//
//  ViewController.h
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudioFile.h"
#import "EZAudioPlayer.h"
#import "EZAudio.h"
#import "PlayButton.h"
#import "NextButton.h"
#import "PrevButton.h"

@interface ViewController : UIViewController

@property UIView* super_view;
@property PlayButton *play_button;
@property NextButton *next_button;
@property PrevButton *prev_button;
@property UILabel *title_label;
@property UILabel *artist_label;
@property BOOL playing;
@property NSMutableArray *spheres;
@property NSThread *sphere_thread;
@property NSTimer *update_timer;
@property NSMutableArray *amp_points;

#define kAudioFileDefault [[NSBundle mainBundle] pathForResource:@"lunar" ofType:@"MP3"]

/**
 An EZAudioFile that will be used to load the audio file at the file path specified
 */
@property (nonatomic, strong) EZAudioFile *audioFile;

//------------------------------------------------------------------------------

/**
 An EZAudioPlayer that will be used for playback
 */
@property (nonatomic, strong) EZAudioPlayer *player;

//------------------------------------------------------------------------------

/**
 The CoreGraphics based audio plot
 */
@property EZAudioPlot *audioPlot;

//------------------------------------------------------------------------------

@end

