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
#import "Interpolate.h"
@interface ViewController : UIViewController

@property UIView* super_view;
@property PlayButton *play_button;
@property NextButton *next_button;
@property PrevButton *prev_button;
@property NavBar *nav_bar;
@property UILabel *title_label;
@property UILabel *artist_label;
@property bool playing;
@property NSMutableArray *spheres;
@property NSThread *sphere_thread;
@property NSTimer *update_timer;
@property NSMutableArray *amp_points;
@property SongController *song_controller;
@property bool queue_is_up;
@property int song_indx;
@property NSTimer *animate_timer;
@property UITabBar *tab_bar;
@property NSArray *ball_colors;
@property bool shinny_mode;
@property EZOutput *output;
@property MPMusicPlayerController *media_player;
@property MPMediaItem *current_song;
@property NSTimeInterval seek_time;

#define kAudioFileDefault [[NSBundle mainBundle] pathForResource:@"motion" ofType:@"mp3"]

/**
 An EZAudioFile that will be used to load the audio file at the file path specified
 */
@property (nonatomic, strong) EZAudioFile *audio_file;

//------------------------------------------------------------------------------

-(void)set_matte;
-(void)set_shinny;
-(void)toggle_play;
-(void)play;
-(void) setSongTitle:(NSString*)title withArtist:(NSString *)artist;

@end

