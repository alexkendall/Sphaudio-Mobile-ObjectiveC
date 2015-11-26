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
#include "Interpolate.h"


@import MediaPlayer;
@import UIKit;
@import SceneKit;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //**************************************************************************************
    //
    // Setup the AVAudioSession. EZMicrophone will not work properly on iOS
    // if you don't do this!
    //
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    //**************************************************************************************
    
    // configure superview
    self.super_view = self.view;
    self.super_view.backgroundColor = [UIColor blackColor];
    
    UIColor *dark_gray = [[UIColor alloc]initWithRed:0.12 green:0.12 blue:0.12 alpha:1.0];
    
    // configure scene view
    SCNView *scene_view = [[SCNView alloc]initWithFrame:self.view.bounds];
    scene_view.antialiasingMode = SCNAntialiasingModeMultisampling4X;
    scene_view.backgroundColor = dark_gray;
    [self.view addSubview:scene_view];
    
    // scene
    SCNScene *scene = [[SCNScene alloc]init];
    scene_view.scene = scene;
    
    // camera
    SCNCamera *camera = [[SCNCamera alloc]init];
    SCNNode *camera_node = [[SCNNode alloc]init];
    camera_node.camera = camera;
    
    // spot light
    SCNLight *spot_light = [[SCNLight alloc]init];
    spot_light.type = SCNLightTypeSpot;
    spot_light.spotInnerAngle = 0.0;
    spot_light.spotOuterAngle = 90.0;
    spot_light.castsShadow = true;
    SCNNode *spot_node = [[SCNNode alloc]init];
    spot_node.light = spot_light;
    spot_node.position = SCNVector3Make(0.0, 10.0, 0.0);

    // ambient light
    SCNLight *ambient_light = [[SCNLight alloc]init];
    ambient_light.type = SCNLightTypeAmbient;
    ambient_light.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    camera_node.light = ambient_light;
    
    // configure spheres
    CGFloat step = 3.0;
    CGFloat origin_x = -6.0;
    int num_rows = 5;
    int num_cols = 5;
    self.spheres = [[NSMutableArray alloc]init];
    
    for(int r = 0; r < num_rows; ++r)
    {
        for(int c = 0; c < num_cols; ++c)
        {
            // sphere geometry
            SCNSphere *sphere_geometry = [[SCNSphere alloc]init];
            sphere_geometry.radius = 1.0;
            
            // sphere node
            SCNNode *sphere_node = [[SCNNode alloc]init];
            sphere_node.geometry = sphere_geometry;
            
            // sphere material
            SCNMaterial *sphere_material = [[SCNMaterial alloc]init];
            sphere_material.diffuse.contents = [UIColor greenColor];
            
            NSArray *materials = @[sphere_material];
            sphere_geometry.materials = materials;
            
            CGFloat x = origin_x + (c * step);
            CGFloat y = r * step;
            sphere_node.position = SCNVector3Make(x, 0.5, y);
            [scene.rootNode addChildNode:sphere_node];
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
    [scene.rootNode addChildNode:floor_node];
    [scene.rootNode addChildNode:spot_node];
    [scene.rootNode addChildNode:camera_node];
    
    SCNNode *center_node = [[SCNNode alloc]init];
    center_node.position = SCNVector3Make(0.0, 0.0, 6.0);
    [scene.rootNode addChildNode:center_node];
    
    // configure camera position and eye
    camera_node.position = SCNVector3Make(0.0, 12.0, 40.0);
    SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:center_node];
    constraint.gimbalLockEnabled = true;
    NSArray *constraints = @[constraint];
    camera_node.constraints = constraints;
    spot_node.constraints = constraints;

    
    // configure play button
    CGFloat width = self.super_view.bounds.size.width * 0.5;
    CGFloat height = self.super_view.bounds.size.height * 0.05;
    CGFloat offset_x = (self.super_view.bounds.size.width - width) * 0.5;
    CGFloat offset_y = self.super_view.bounds.size.height * 0.05;
    
    // configure play button
    /*
    self.play_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.play_button.frame = CGRectMake(offset_x, offset_y, width, height);
    self.play_button.backgroundColor = [UIColor whiteColor];
    self.play_button.layer.cornerRadius = height * 0.15;
    
    // configure title properties
    [self.play_button setTitle:@"Play" forState:UIControlStateNormal];
    [self.play_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.play_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.super_view addSubview:self.play_button];
    */
    
    // add targets for playing song
    [self.play_button addTarget:self action:@selector(play_song) forControlEvents:UIControlEventTouchUpInside];
    self.playing = false;
    
    // configure audio plot
    CGFloat plot_height = self.view.bounds.size.height * 0.2;
    CGFloat plot_width = self.view.bounds.size.width;
    CGFloat plot_y = self.view.bounds.size.height - plot_height;
    
    //
    self.audioPlot = [[EZAudioPlot alloc] initWithFrame:CGRectMake(0.0, plot_y, plot_width, plot_height)];
    self.audioPlot.frame = CGRectMake(0.0, plot_y, plot_width, plot_height);
    
    // configure plot visuals
    self.audioPlot.backgroundColor = [UIColor clearColor];
    self.audioPlot.color           = [UIColor whiteColor];
    self.audioPlot.plotType        = EZPlotTypeRolling;
    self.audioPlot.shouldFill      = NO;
    self.audioPlot.shouldMirror    = YES;
    
    // add plot to subview
    //[self.super_view addSubview:self.audioPlot];
    
    
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
    
    // generate thread for handling sphere animations and rendering
    NSThread *ball_thread = [[NSThread alloc]initWithTarget:self selector:@selector(animate) object:nil];
    [self animate];
    
    
    // configure timer for updating spheres
    //self.amp_points = [[NSMutableArray alloc]init];
    //self.update_timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animate) userInfo:nil repeats:true];
    
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
    
    // configure previous button
    self.prev_button = [[PrevButton alloc]init];
    CGFloat prev_dim = self.view.frame.size.width * 0.06;
    CGFloat prev_offset_x = (self.view.frame.size.width - next_dim) * 0.5 - (play_dim * 3.0);
    CGFloat prev_offset_y = self.view.frame.size.height * 0.705;
    self.prev_button.frame = CGRectMake(prev_offset_x, prev_offset_y, prev_dim, prev_dim);
    [self.view addSubview:self.prev_button];
    
    // configure navigation button
    self.nav_bar = [[NavBar alloc]init];
    CGFloat nav_dim = self.view.frame.size.width * 0.07;
    CGFloat margin = self.view.frame.size.width * 0.05;
    self.nav_bar.frame = CGRectMake(margin, margin, nav_dim * 1.25, nav_dim);
    [self.nav_bar addTarget:self.nav_bar action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.nav_bar addTarget:self action:@selector(toggle_queue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nav_bar];
    
    // set queue is up to false
    self.song_controller = [[SongController alloc]init];
    self.queue_is_up = false;
    self.song_indx = 0;
    
    
    //**************************************************************************************
    
    NSLog(@"outputs: %@", [EZAudioDevice outputDevices]);
    
    //
    // Create the audio player
    //
    self.player = [EZAudioPlayer audioPlayerWithDelegate:self];
    self.player.shouldLoop = YES;
    // Override the output to the speaker
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if (error)
    {
        NSLog(@"Error overriding output to the speaker: %@", error.localizedDescription);
    }
    
    //
    // Customize UI components
    //
    //self.rollingHistorySlider.value = (float)[self.audioPlot rollingHistoryLength];
    
    //
    // Listen for EZAudioPlayer notifications
    //
    [self setupNotifications];
    
    /*
     Try opening the sample file
     */
    [self openFileWithFilePathURL:[NSURL fileURLWithPath:kAudioFileDefault]];

    //**************************************************************************************
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)play_song
{
    
    if(self.playing)
    {
        
        printf("pausing song\n");
        [self.play_button setTitle:@"Play" forState:UIControlStateNormal];
        self.playing = false;
        [self.player pause];
    }
    else
    {
        printf("playing song\n");
        [self.play_button setTitle:@"Pause" forState:UIControlStateNormal];
        self.playing = true;
        [self.player play];
        
    }
}

//------------------------------------------------------------------------------
#pragma mark - Notifications
//------------------------------------------------------------------------------

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangeAudioFile:)
                                                 name:EZAudioPlayerDidChangeAudioFileNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangeOutputDevice:)
                                                 name:EZAudioPlayerDidChangeOutputDeviceNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangePlayState:)
                                                 name:EZAudioPlayerDidChangePlayStateNotification
                                               object:self.player];
}

//------------------------------------------------------------------------------

- (void)audioPlayerDidChangeAudioFile:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player changed audio file: %@", [player audioFile]);
}

//------------------------------------------------------------------------------

- (void)audioPlayerDidChangeOutputDevice:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player changed output device: %@", [player device]);
}

//------------------------------------------------------------------------------

- (void)audioPlayerDidChangePlayState:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player change play state, isPlaying: %i", [player isPlaying]);
}

//------------------------------------------------------------------------------
#pragma mark - Actions
//------------------------------------------------------------------------------

- (void)changePlotType:(id)sender
{
    NSInteger selectedSegment = [sender selectedSegmentIndex];
    switch(selectedSegment)
    {
        case 0:
            [self drawBufferPlot];
            break;
        case 1:
            [self drawRollingPlot];
            break;
        default:
            break;
    }
}


- (void)openFileWithFilePathURL:(NSURL *)filePathURL
{
    //
    // Create the EZAudioPlayer
    //
    self.audioFile = [EZAudioFile audioFileWithURL:filePathURL];
    
    //
    // Update the UI
    //
    
    
    //self.filePathLabel.text = filePathURL.lastPathComponent;
    //self.positionSlider.maximumValue = (float)self.audioFile.totalFrames;
    //self.volumeSlider.value = [self.player volume];
    
    //
    // Plot the whole waveform
    //
    self.audioPlot.plotType = EZPlotTypeBuffer;
    self.audioPlot.shouldFill = YES;
    self.audioPlot.shouldMirror = YES;
    __weak typeof (self) weakSelf = self;
    [self.audioFile getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                         int length)
     {
         [weakSelf.audioPlot updateBuffer:waveformData[0]
                           withBufferSize:length];
     }];
    
    //
    // Play the audio file
    //
    [self.player setAudioFile:self.audioFile];
    
    
}

//------------------------------------------------------------------------------

- (void)seekToFrame:(id)sender
{
    [self.player seekToFrame:(SInt64)[(UISlider *)sender value]];
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
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.audioPlot updateBuffer:buffer[0]
                          withBufferSize:bufferSize];
    });
}

//------------------------------------------------------------------------------

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
    updatedPosition:(SInt64)framePosition
        inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

//------------------------------------------------------------------------------
#pragma mark - Utility
//------------------------------------------------------------------------------

/*
 Give the visualization of the current buffer (this is almost exactly the openFrameworks audio input eample)
 */
- (void)drawBufferPlot
{
    printf("BUFFER");
    self.audioPlot.plotType = EZPlotTypeBuffer;
    self.audioPlot.shouldMirror = NO;
    self.audioPlot.shouldFill = NO;
}

//------------------------------------------------------------------------------

/*
 Give the classic mirrored, rolling waveform look
 */
- (void)drawRollingPlot
{
    printf("ROLLING");
    self.audioPlot.plotType = EZPlotTypeRolling;
    self.audioPlot.shouldFill = NO;
    self.audioPlot.shouldMirror = YES;
}

//------------------------------------------------------------------------------

-(void)toggle_play
{
    if(self.playing)
    {
        self.playing = false;
        [self.player pause];
        [self.update_timer invalidate];
    }
    else
    {
        if(self.song_controller.songs_array.count > 0)
        {
            MPMediaItem *song = self.song_controller.songs_array[0];
            [self.player openMediaItem:song completion:^(EZAudioFile *audioFile,
                                                                NSError *error)
            {
                NSLog(@"audio file: %@, error: %@", audioFile, error);
            }];
        }
        
        //self.player.audioFile = [[EZAudioFile alloc]initWithURL:song_url delegate:self];
        self.playing = true;
        [self.player play];
        self.update_timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animate) userInfo:nil repeats:true];
    }
}

//------------------------------------------------------------------------------

-(void)toggle_queue
{
    printf("Bringing up queue");
    
    if(self.queue_is_up)
    {
        // take down song controller
        self.queue_is_up = false;
        [self.song_controller.view removeFromSuperview];
        self.song_controller.table_view.reloadData;
        [self.song_controller reset_state];
    }
    else
    {
        // put up song controller
        self.queue_is_up = true;
        [self.view addSubview:self.song_controller.view];
    }
}

//------------------------------------------------------------------------------

-(void)play_song_with:(NSURL*)url
{
    return;
}

//------------------------------------------------------------------------------

/*
 Sample num random data points from wavelength 
 */
- (void)animate
{
    //printf("animate!");
    
    EZAudioFloatData *wave_data = [self.audioFile getWaveformDataWithNumberOfPoints:1024];
    float* data = [wave_data bufferForChannel:0];
    int NUM_SPHERES = 25;
    int SAMPLE_RANGE = ceil(1024.0 / 25.0);
    
    if(data != nil)
    {
        printf("sampling rand!");
        
        float max_area = 0.0;
        
        // pass 1 get max area, use this for speed
        for(int i = 0; i < NUM_SPHERES; ++i)
        {
            // set sample start and end indexes
            int start_index = i * SAMPLE_RANGE;
            int end_index = start_index + SAMPLE_RANGE;
            float area = 0;
            
            // sample points in range, take peak and area
            for(int i = start_index; i < end_index; ++i)
            {
                float this_point = fabs(data[i]);
                area += this_point;
            }
            if(area > max_area)
            {
                max_area = area;
            }
        }
        
        // get max area... ball responsible for this frequency will be in the air the longest
        float sample_speed = 2.0;
        float speed_mult = sample_speed / max_area;
        
        // color array for interpolation
        NSArray *freq_colors = @[[UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor redColor]];
        
        // pass 2 use max area accordingly
        for(int i = 0; i < NUM_SPHERES; ++i)
        {
            // set sample start and end indexes
            int start_index = i * SAMPLE_RANGE;
            int end_index = start_index + SAMPLE_RANGE;
            float area = 0;
            float max = 0;
            
            // sample points in range, take peak and area
            for(int i = start_index; i < end_index; ++i)
            {
                float this_point = fabs(data[i]);
                area += this_point;
                if(this_point > max)
                {
                    max = this_point;
                }
            }
            
            //printf("Amplitude: %f\nArea: %f\n", max, area);

            // measure y amplitude
            float y_amplitude = max * 40.0;
            
            // use half speed for ball up, half for ball down
            float ball_speed = area * speed_mult * 0.5;
            
            // determine ball color according to frequency
            
            float t_value = 0.0;
            t_value = area / max_area;
            UIColor *up_color = [[UIColor alloc]init];
            UIColor *down_color = [[UIColor alloc]init];

        
            UIColor *light_blue = [[UIColor alloc]initWithRed:0.0 green:233.0 / 255.0 blue:1.0 alpha:1.0];
            UIColor *teal = [[UIColor alloc]initWithRed:0.0 green:159.0 / 255.0 blue:165.0 / 255.0 alpha:1.0];
            UIColor *soft_green = [[UIColor alloc]initWithRed:0.0 green:179.0 / 255.0 blue:97.0 / 255.0 alpha:1.0];
            UIColor *yellow_orange = [[UIColor alloc]initWithRed:1.0 green:198.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
            UIColor *red_orange = [[UIColor alloc]initWithRed:1.0 green:107.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
            UIColor *bright_red = [[UIColor alloc]initWithRed:1.0 green:23.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
            UIColor *dark_red = [[UIColor alloc]initWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
            if(t_value < 0.17)
            {
                down_color = light_blue;
                up_color = teal;
            }
            else if(t_value < 0.34)
            {
                down_color = teal;
                up_color = soft_green;
            }
            else if(t_value < 0.5)
            {
                down_color = soft_green;
                up_color = yellow_orange;
            }
            else if(t_value < 0.68)
            {
                down_color = yellow_orange;
                up_color = red_orange;
            }
            else if(t_value < 0.85)
            {
                down_color = red_orange;
                up_color = bright_red;
            }
            else
            {
                down_color = bright_red;
                up_color = dark_red;
            }
            
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:ball_speed];
            SCNNode *sphere = self.spheres[i];
            sphere.position = SCNVector3Make(sphere.position.x, y_amplitude, sphere.position.z);
            sphere.geometry.materials[0].diffuse.contents = up_color;
            [SCNTransaction setCompletionBlock:^
             {
                 [SCNTransaction begin];
                 [SCNTransaction setAnimationDuration:ball_speed];
                 sphere.position = SCNVector3Make(sphere.position.x, 0.5, sphere.position.z);
                 sphere.geometry.materials[0].diffuse.contents = down_color;
                 [SCNTransaction commit];
                 
             }];
            [SCNTransaction commit];
        }
    }

}

@end
