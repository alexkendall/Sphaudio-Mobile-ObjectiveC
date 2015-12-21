//
//  ViewController.m
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import "ViewController.h"
#import "EZAudioFile.h"
#import "EZAudioPlayer.h"
#import "EZAudioPlot.h"
#import "PlayButton.h"
#import "NextButton.h"
#include "SPHNode.h"
#include "AppDelegate.h"

@import MediaPlayer;
@import UIKit;
@import SceneKit;
#import "Icon.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // configure superview
    self.super_view = self.view;
    self.super_view.backgroundColor = [UIColor blackColor];
    
    
    UIColor *dark_gray = [[UIColor alloc]initWithRed:0.125 green:0.125 blue:0.125 alpha:1.0];
    
    // configure scene view
    SCNView *scene_view = [[SCNView alloc]initWithFrame:self.view.bounds];
    scene_view.antialiasingMode = SCNAntialiasingModeMultisampling4X;
    scene_view.backgroundColor = dark_gray;
    [self.view addSubview:scene_view];
    
    // scene
    self.scene = [[SCNScene alloc]init];
    scene_view.scene = self.scene;
    
    // camera
    SCNCamera *camera = [[SCNCamera alloc]init];
    self.camera_node = [[SCNNode alloc]init];
    self.camera_node.camera = camera;
    
    // spot light
    SCNLight *spot_light = [[SCNLight alloc]init];
    spot_light.type = SCNLightTypeSpot;
    spot_light.spotInnerAngle = 0.0;
    spot_light.spotOuterAngle = 90.0;
    spot_light.castsShadow = true;
    SCNNode *spot_node = [[SCNNode alloc]init];
    spot_node.light = spot_light;
    spot_node.position = SCNVector3Make(0.0, 10.0, 0.0);
    
    // point light
    SCNLight *point_light = [[SCNLight alloc]init];
    point_light.type = SCNLightTypeOmni;
    point_light.castsShadow = true;
    point_light.spotInnerAngle = 0.0;
    point_light.spotOuterAngle = 45.0;
    point_light.attenuationEndDistance = 20.0;
    
    SCNNode *point_node = [[SCNNode alloc]init];
    point_node.light = point_light;
    point_node.position = SCNVector3Make(0.0, 10.0, 20.0);
    
    // ambient light
    SCNLight *ambient_light = [[SCNLight alloc]init];
    ambient_light.type = SCNLightTypeAmbient;
    ambient_light.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    self.camera_node.light = ambient_light;
    
    // configure spheres
    CGFloat step = 3.0;
    CGFloat origin_x = -9.0;
    int num_rows = 7;
    int num_cols = 7;
    self.spheres = [[NSMutableArray alloc]init];
    
    for(int r = 0; r < num_rows; ++r)
    {
        for(int c = 0; c < num_cols; ++c)
        {
            // sphere geometry
            SCNSphere *sphere_geometry = [[SCNSphere alloc]init];
            sphere_geometry.radius = 1.0;
            
            // sphere node
            SCNNode *sphere_node = [[SPHNode alloc]init];
            sphere_node.geometry = sphere_geometry;
            
            // sphere material
            UIColor *light_blue = [[UIColor alloc]initWithRed:0.0 green:233.0 / 255.0 blue:1.0 alpha:1.0];
            SCNMaterial *sphere_material = [[SCNMaterial alloc]init];
            sphere_material.diffuse.contents = light_blue;
            
            NSArray *materials = @[sphere_material];
            sphere_geometry.materials = materials;
            
            // shininess
            CGFloat x = origin_x + (c * step);
            CGFloat y = r * step;
            sphere_node.position = SCNVector3Make(x, 0.5, y);
            [self.scene.rootNode addChildNode:sphere_node];
            [self.spheres addObject:sphere_node];
            
        }
    }
    
    // generate floor
    SCNPlane *floor_geometry = [[SCNPlane alloc]init];
    floor_geometry.width = 1000.0;
    floor_geometry.height = 1000.0;
    
    SCNNode *floor_node = [[SCNNode alloc]init];
    floor_node.geometry = floor_geometry;
    floor_node.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90), 0, 0);
    floor_node.position = SCNVector3Make(0.0, -0.5, 0.0);
    
    // sphere material
    SCNMaterial *floor_material = [[SCNMaterial alloc]init];
    UIColor *dark_gray_color = [[UIColor alloc]initWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    
    floor_material.diffuse.contents = dark_gray_color;
    
    NSArray *materials = @[floor_material];
    floor_geometry.materials = materials;
    [self.scene.rootNode addChildNode:floor_node];
    [self.scene.rootNode addChildNode:spot_node];
    [self.scene.rootNode addChildNode:self.camera_node];
    [self.scene.rootNode addChildNode:point_node];
    
    SCNNode *center_node = [[SCNNode alloc]init];
    center_node.position = SCNVector3Make(0.0, 0.0, 6.0);
    [self.scene.rootNode addChildNode:center_node];
    
    // configure camera position and eye
    self.camera_node.position = SCNVector3Make(0.0, 15.0, 50.0);
    SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:center_node];
    constraint.gimbalLockEnabled = true;
    NSArray *constraints = @[constraint];
    self.camera_node.constraints = constraints;
    spot_node.constraints = constraints;
    
    // configure song title label
    CGFloat label_height = 40.0;
    CGFloat label_width = self.view.bounds.size.width;
    CGFloat title_y = self.view.bounds.size.height * 0.2;
    self.title_label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, title_y, label_width, label_height)];
    [self.title_label setText:@"The Motion (Instrumental)"];
    [self.title_label setTextColor:[UIColor whiteColor]];
    [self.title_label setTextAlignment:NSTextAlignmentCenter];
    self.title_label.font = [UIFont boldSystemFontOfSize:18.0];
    
    // configure song artest label
    CGFloat artist_y = title_y + 30.0;
    self.artist_label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, artist_y, label_width, label_height)];
    [self.artist_label setText:@"Drake"];
    [self.artist_label setTextColor:[UIColor whiteColor]];
    [self.artist_label setTextAlignment:NSTextAlignmentCenter];
    self.artist_label.font = [UIFont systemFontOfSize:17.0];
    
    
    [self.super_view addSubview:self.title_label];
    [self.super_view addSubview:self.artist_label];
    
    
    // configure play button
    self.play_button = [[PlayButton alloc]init];
    CGFloat play_dim = self.view.frame.size.width * 0.075;
    CGFloat play_offset_x = (self.view.frame.size.width - play_dim) * 0.5;
    CGFloat play_offset_y = self.view.frame.size.height * 0.7;
    self.play_button.frame = CGRectMake(play_offset_x, play_offset_y, play_dim, play_dim);
    
    // add target to toggle play on and off
    [self.play_button addTarget:self action:@selector(toggle_play) forControlEvents:UIControlEventTouchUpInside];
    
    // set state
    [self.play_button set_playing];
    
    // add to view hiearchy
    [self.view addSubview:self.play_button];
    
    // configure next button
    self.next_button = [[NextButton alloc]init];
    CGFloat next_dim = self.view.frame.size.width * 0.06;
    CGFloat next_offset_x = (self.view.frame.size.width - next_dim) * 0.5 + (play_dim * 3.0);
    CGFloat next_offset_y = self.view.frame.size.height * 0.705;
    self.next_button.frame = CGRectMake(next_offset_x, next_offset_y, next_dim, next_dim);
    [self.view addSubview:self.next_button];
    [self.next_button addTarget:self action:@selector(skip_next) forControlEvents:UIControlEventTouchUpInside];
    
    // configure previous button
    self.prev_button = [[PrevButton alloc]init];
    CGFloat prev_dim = self.view.frame.size.width * 0.06;
    CGFloat prev_offset_x = (self.view.frame.size.width - next_dim) * 0.5 - (play_dim * 3.0);
    CGFloat prev_offset_y = self.view.frame.size.height * 0.705;
    self.prev_button.frame = CGRectMake(prev_offset_x, prev_offset_y, prev_dim, prev_dim);
    [self.view addSubview:self.prev_button];
    [self.prev_button addTarget:self action:@selector(skip_prev) forControlEvents:UIControlEventTouchUpInside];
    
    // setup ball color array
    UIColor *light_blue = [[UIColor alloc]initWithRed:0.0 green:233.0 / 255.0 blue:1.0 alpha:1.0];
    UIColor *teal = [[UIColor alloc]initWithRed:0.0 green:159.0 / 255.0 blue:165.0 / 255.0 alpha:1.0];
    UIColor *soft_green = [[UIColor alloc]initWithRed:0.0 green:179.0 / 255.0 blue:97.0 / 255.0 alpha:1.0];
    UIColor *yellow_orange = [[UIColor alloc]initWithRed:1.0 green:198.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *red_orange = [[UIColor alloc]initWithRed:1.0 green:107.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *bright_red = [[UIColor alloc]initWithRed:1.0 green:23.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *dark_red = [[UIColor alloc]initWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
    
    
    self.ball_colors = @[light_blue, teal, soft_green, yellow_orange, red_orange, bright_red, dark_red];
    
    // set to not shinny by default
    self.shinny_mode = false;
    
    // load up all of systems music into queue, load first song into player
    AppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
    SongController *song_controller = app_delegate.songs_controller;
    [song_controller.table_view reloadData];
    
    
    MPMediaItem *first_song = song_controller.songs_array.firstObject;
    if(first_song != nil)
    {
        NSURL *item_url = [first_song valueForKey:MPMediaItemPropertyAssetURL];
        [self setSongTitle:first_song.title withArtist:first_song.artist];
        self.audio_file = [[EZAudioFile alloc]initWithURL: item_url];
        self.player = [[EZAudioPlayer alloc]initWithAudioFile:self.audio_file delegate:self];
        self.playing = false;
        [self.play_button set_playing];
    }
    
    // seek slider
    CGFloat slider_width = self.view.bounds.size.width * 0.7;
    CGFloat slider_margin = (self.view.bounds.size.width - slider_width) * 0.5;
    CGFloat slider_y = self.view.bounds.size.height * 0.8125;
    CGFloat slider_height = 20.0;
    self.seek_slider = [[UISlider alloc]initWithFrame:CGRectMake(slider_margin, slider_y, slider_width, slider_height)];
    [self.view addSubview:self.seek_slider];
    [self.seek_slider addTarget:self action:@selector(manual_seek) forControlEvents:UIControlEventTouchDragInside];
    self.seek_slider.minimumTrackTintColor = light_blue;
    
    // update seek slider every second
    NSTimer *seek_update_timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(auto_seek) userInfo:nil repeats:true];
    [seek_update_timer fire];
    
    
    // configure according to save settings information
     SettingsController *settings_controller = app_delegate.settings_controller;
     
    // flush updated settings to
    app_delegate.tab_controller.selectedViewController = settings_controller;
    app_delegate.tab_controller.selectedViewController = self;
    
    
    // test image
    /*
    CGRect image_rect = CGRectMake(0.0, 0.0, 100.0, 100.0);
    UIImage *image = get_sphaudio_icon(&image_rect);
    UIImageView *image_view = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:image_view];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------

-(void)toggle_play
{
    
    if(self.playing)
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}

//------------------------------------------------------------------------------

-(void)skip_next
{
    printf("playing next");
    AppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
    SongController *song_controller = app_delegate.songs_controller;
    
    long num_songs = song_controller.songs_array.count;
    
    
    if(num_songs > 0)
    {
        if(song_controller.song_index < (num_songs - 1))
        {
            ++song_controller.song_index;
            
        }
        else if (song_controller.song_index >= (num_songs - 1))
        {
            song_controller.song_index = 0;
        }
        
        MPMediaItem *selected_song = song_controller.songs_array[song_controller.song_index];
        NSURL *song_url = [selected_song valueForKey:MPMediaItemPropertyAssetURL];
        self.audio_file = [[EZAudioFile alloc]initWithURL:song_url];

        // flush display of new song title and artist
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *     NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setSongTitle:selected_song.title withArtist:selected_song.artist];
        });
        
        // play song
        self.player.audioFile = self.audio_file;
        [self play];
    }
    
    
    
}

//------------------------------------------------------------------------------

-(void)skip_prev
{
    printf("playing previous\n");
    AppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
    SongController *song_controller = app_delegate.songs_controller;
    
    long num_songs = song_controller.songs_array.count;
    
    if(num_songs > 0)
    {
        if(song_controller.song_index <= 0)
        {
            song_controller.song_index = (int)num_songs - 1;
            
        }
        else
        {
            --song_controller.song_index;
        }
        
        MPMediaItem *selected_song = song_controller.songs_array[song_controller.song_index];
        NSURL *song_url = [selected_song valueForKey:MPMediaItemPropertyAssetURL];
        self.audio_file = [[EZAudioFile alloc]initWithURL:song_url];
        
        // flush display of new song title and artist
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *     NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setSongTitle:selected_song.title withArtist:selected_song.artist];
        });
        
        // play song
        self.player.audioFile = self.audio_file;
        
        [self play];
    }
}

//------------------------------------------------------------------------------


-(void)play
{
    printf("playing song\n");
    self.playing = true;
    [self.player play];
    [self.play_button set_paused];
}

//------------------------------------------------------------------------------

-(void)pause
{
    printf("pausing song\n");
    self.playing = false;
    
    while (self.player.isPlaying) {
        [self.player pause];
    }
    [self.play_button set_playing];
}

//------------------------------------------------------------------------------

-(void)set_shinny
{
    for(int i = 0; i < self.spheres.count; ++i)
    {
        SCNNode *sphere = self.spheres[i];
        SCNMaterial *material = sphere.geometry.materials[0];
        material.specular.contents = [UIColor whiteColor];
        material.shininess = 0.5;
    }
}

//------------------------------------------------------------------------------

-(void)set_matte
{
    for(int i = 0; i < self.spheres.count; ++i)
    {
        SCNNode *sphere = self.spheres[i];
        SCNMaterial *material = sphere.geometry.materials[0];
        material.specular.contents = @[];
        material.shininess = 0.0;
    }
}

//------------------------------------------------------------------------------

-(void)auto_seek
{
    CGFloat current_time = self.player.currentTime;
    CGFloat duration = self.player.duration;
    
    printf("\n\nDuration: %f\nCurrent Time: %f\n", duration, current_time);
    //CGFloat t_val = current_time / duration;
    self.seek_slider.minimumValue = 0.0;
    self.seek_slider.maximumValue = duration;
    self.seek_slider.value = current_time;
}

-(void)manual_seek
{
    printf("\n\nManual Seek\n\n");
    
    // get previous state
    bool was_playing = self.playing;
    
    // stop playback where it currently is
    [self pause];
    
    // get number of frames in audio file
    int num_frames = (int)self.player.audioFile.totalFrames;
    
    // get relative position of slider
    float t_val = self.seek_slider.value / self.seek_slider.maximumValue;
    int seek_frame = (float)num_frames * t_val;
    
    // seek to corresponding frame
    [self.player seekToFrame:seek_frame];
    
    // resume to old state with new seek position
    if(was_playing)
    {
        [self play];
    }
    else
    {
        [self pause];
    }
    
    
}

//------------------------------------------------------------------------------

/*
 Sample data points from wavelength -> load into memory
 */
- (void)animate
{
    int NUM_SPHERES = 49;
    for(int i = 0; i < NUM_SPHERES; ++i)
    {
        SPHNode *sphere = self.spheres[i];
        
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:sphere.duration];
        sphere.position = SCNVector3Make(sphere.position.x, sphere.amplitude, sphere.position.z);
        sphere.geometry.materials[0].diffuse.contents = sphere.up_color;
        [SCNTransaction setCompletionBlock:^
         {
             [SCNTransaction begin];
             [SCNTransaction setAnimationDuration:sphere.duration];
             sphere.position = SCNVector3Make(sphere.position.x, 0.5, sphere.position.z);
             sphere.geometry.materials[0].diffuse.contents = sphere.down_color;
             [SCNTransaction commit];
             
         }];
        [SCNTransaction commit];
    }
}

//------------------------------------------------------------------------------

-(void) setSongTitle:(NSString*)title withArtist:(NSString *)artist
{
    self.title_label.text = title;
    self.artist_label.text = artist;
}


//------------------------------------------------------------------------------
#pragma mark - EZAudioPlayerDelegate
//------------------------------------------------------------------------------

- (void)  audioPlayer:(EZAudioPlayer *)audioPlayer
          playedAudio:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
          inAudioFile:(EZAudioFile *)audioFile
{
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    
    float *_buffer = buffer[0]; // sample one channel
    int span = bufferSize / self.NUM_SPHERES;
    int start_index = 0;
    int end_index = 0;
    
    self.seek_slider.minimumTrackTintColor = self.ball_colors[0];
    
    // first pass
    for(int i = 0; i < self.NUM_SPHERES; ++i)
    {
        start_index = span * i;
        end_index = start_index + span;
        float amp_sum = 0;
        for(int j = start_index; j < end_index;)
        {
            ++j;
            amp_sum += _buffer[j];
        }
        float avg_amplitude = amp_sum / span;
        
        float mult = 80;
        float y = avg_amplitude * mult;
        if(y < 0.5)
        {
            y = 0.5;
        }
        SCNNode *sphere = self.spheres[i];
        sphere.position = SCNVector3Make(sphere.position.x, y, sphere.position.z);
        
        if(y < 2.0)
        {
            sphere.geometry.materials[0].diffuse.contents = self.ball_colors[0];
        }
        else if(y < 4.0)
            //else if(t_value < 0.01)
        {
            sphere.geometry.materials[0].diffuse.contents = self.ball_colors[1];
        }
        else if(y < 6.0)
        {
            sphere.geometry.materials[0].diffuse.contents = self.ball_colors[2];
        }
        else if(y < 8.0)
        {
            sphere.geometry.materials[0].diffuse.contents = self.ball_colors[3];
        }
        else if(y < 10.0)
        {
            sphere.geometry.materials[0].diffuse.contents = self.ball_colors[4];
        }
        else
        {
            sphere.geometry.materials[0].diffuse.contents = self.ball_colors[5];
        }
    }
    
}
//------------------------------------------------------------------------------

-(void)load_spheres
{
    int num_rows = sqrt(self.NUM_SPHERES);
    int num_cols = num_rows;
    
    // configure spheres
    CGFloat step = 3.0;
    CGFloat origin_x = -6.0;
    self.camera_node.position = SCNVector3Make(0.0, 12.0, 40.0);
    
    if(self.NUM_SPHERES == 25)
    {
        // keep spheres 0-23 in view
        // move spheres 24-48 out of view
        for(int i = 24; i < 49; ++i)
        {
            SCNNode *sphere_node = self.spheres[i];
            sphere_node.position = SCNVector3Make(100.0, 0.0, 0.0);
        }
    }
    else
    {
        origin_x = -9.0;
        self.camera_node.position = SCNVector3Make(0.0, 15.0, 50.0);
    }
    
    for(int r = 0; r < num_rows; ++r)
    {
        for(int c = 0; c < num_cols; ++c)
        {
            int sphere_index = (r * num_cols) + c;
            SCNNode *sphere_node = self.spheres[sphere_index];
            CGFloat x = origin_x + (c * step);
            CGFloat y = r * step;
            sphere_node.position = SCNVector3Make(x, 0.5, y);
        }
    }    
}

//------------------------------------------------------------------------------

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
    updatedPosition:(SInt64)framePosition
        inAudioFile:(EZAudioFile *)audioFile
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

//------------------------------------------------------------------------------

/**
 Triggered by EZAudioPlayer's internal EZAudioFile's EZAudioFileDelegate callback and notifies the delegate that the end of the file has been reached.
 @param audioPlayer The instance of the EZAudioPlayer that triggered the event
 @param audioFile   The instance of the EZAudioFile that the event was triggered from
 */
- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
reachedEndOfAudioFile:(EZAudioFile *)audioFile;
{
    [self skip_next];
}

@end