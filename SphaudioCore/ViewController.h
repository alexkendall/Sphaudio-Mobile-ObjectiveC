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
#import "NavBar.h"
#import "SongController.h"
@import SceneKit;
@interface ViewController : UIViewController

@property UIView* super_view;
@property PlayButton *play_button;
@property NextButton *next_button;
@property PrevButton *prev_button;
@property UILabel *title_label;
@property UILabel *artist_label;
@property bool playing;
@property NSMutableArray *spheres;
@property NSArray *ball_colors;
@property bool shinny_mode;
@property MPMediaItem *current_song;
@property EZAudioPlayer *player;
@property EZAudioFile *audio_file;
@property int NUM_SPHERES;
@property SCNNode *camera_node;
@property SCNScene *scene;
@property UISlider *seek_slider;
@property bool seek_dragged;
#define kAudioFileDefault [[NSBundle mainBundle] pathForResource:@"motion" ofType:@"mp3"]

//------------------------------------------------------------------------------

-(void)set_matte;
-(void)set_shinny;
-(void)toggle_play;
-(void)play;
-(void)pause;
-(void) setSongTitle:(NSString*)title withArtist:(NSString *)artist;
-(void)load_spheres;
-(void)manual_seek;
@end