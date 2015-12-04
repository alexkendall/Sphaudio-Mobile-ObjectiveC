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
#include "SPHNode.h"

@import MediaPlayer;
@import UIKit;
@import SceneKit;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    
    // configure previous button
    self.prev_button = [[PrevButton alloc]init];
    CGFloat prev_dim = self.view.frame.size.width * 0.06;
    CGFloat prev_offset_x = (self.view.frame.size.width - next_dim) * 0.5 - (play_dim * 3.0);
    CGFloat prev_offset_y = self.view.frame.size.height * 0.705;
    self.prev_button.frame = CGRectMake(prev_offset_x, prev_offset_y, prev_dim, prev_dim);
    [self.view addSubview:self.prev_button];
    
    
    // set queue is up to false
    self.song_controller = [[SongController alloc]init];
    self.queue_is_up = false;
    self.song_indx = 0;
    
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
    
    // confihgure audio player
    self.media_player = [[MPMusicPlayerController alloc]init];
    
    // set seek time to 0
    self.seek_time = 0.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)play_song
{
    if(self.playing)
    {
        [self openMediaItem:self.current_song completion:^(EZAudioFile *audioFile,
                 NSError *error)
        {
            NSLog(@"audio file: %@, error: %@", audioFile, error);
        }];

        
        printf("pausing song\n");
        [self.play_button setTitle:@"Play" forState:UIControlStateNormal];
        self.playing = false;
        [self.media_player pause];
    }
    else
    {
        printf("playing song\n");
        [self.play_button setTitle:@"Pause" forState:UIControlStateNormal];
        self.playing = true;
        [self.media_player play];
        
    }
}

//------------------------------------------------------------------------------

-(void)toggle_play
{
    [self openMediaItem:self.current_song completion:^(EZAudioFile *audioFile,
                                                                                NSError *error)
     {
         NSLog(@"audio file: %@, error: %@", audioFile, error);
     }];
    printf("\nPlay toggle\n");
    
    if(self.playing)
    {
        self.playing = false;
        [self.media_player pause];
        [self.update_timer invalidate];
        [self.animate_timer invalidate];
    }
    else
    {
        self.playing = true;
        [self.media_player play];
        
        self.update_timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(begin_retrieval) userInfo:nil repeats:true];
        [self performSelectorInBackground:@selector(update_timer) withObject:nil];
        
        
        self.animate_timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(begin_animation) userInfo:nil repeats:false];
    }
}

//------------------------------------------------------------------------------

-(void)begin_animation
{
    self.animate_timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(animate) userInfo:nil repeats:true];
}

-(void) begin_retrieval
{
    [self performSelectorInBackground:@selector(get_data) withObject:nil];
}

//------------------------------------------------------------------------------

- (void)get_data
{
    NSDate *methodStart = [NSDate date];
    
    // get sample rate
    float SAMPLE_RATE = self.audio_file.totalClientFrames / self.audio_file.duration;
    printf("SAMPLE RATE : %f\n", SAMPLE_RATE);
    
    // get current time in song
    self.seek_time += 1.0;
    
    // seek to frame
    [self.audio_file seekToFrame:SAMPLE_RATE * self.seek_time];
    
    int NUM_POINTS = 1024;
    EZAudioFloatData *wave_data = [self.audio_file getWaveformDataWithNumberOfPoints:NUM_POINTS];
    float* data = [wave_data bufferForChannel:0];
    
    
    int NUM_SPHERES = 25;
    int SAMPLE_RANGE = ceil(NUM_POINTS / 25.0);
    

    if(data != nil)
    {
        float max_area = 0.0;
        float global_max_amplitude = 0.0;
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
                if(this_point > global_max_amplitude)
                {
                    global_max_amplitude = this_point;
                }
            }
            if(area > max_area)
            {
                max_area = area;
            }
        }
        
        printf("Max Area: %f",max_area);
        
        // get max area... ball responsible for this frequency will be in the air the longest
        float sample_speed = 2.0;
        float speed_mult = sample_speed / max_area;
        
        float max_y = 12.0;
        float amp_mult = max_y / global_max_amplitude;
        
        // pass 2 use max area accordingly
        for(int i = 0; i < NUM_SPHERES; ++i)
        {
            
            // set sample start and end indexes
            int start_index = i * SAMPLE_RANGE;
            int end_index = start_index + SAMPLE_RANGE;
            float area = 0;
            float local_max = 0;
            
            // sample points in range, take peak and area
            for(int i = start_index; i < end_index; ++i)
            {
               
                float this_point = fabs(data[i]);
                area += this_point;
                if(this_point > local_max)
                {
                    local_max = this_point;
                }
            }
            
            // measure y amplitude
            float y_amplitude = local_max * amp_mult;
            
            // use half speed for ball up, half for ball down
            float ball_speed = area * speed_mult * 0.5;
            
            // determine ball color according to frequency
            
            float t_value = 0.0;
            t_value = area / max_area;
            UIColor *up_color = [[UIColor alloc]init];
            UIColor *down_color = [[UIColor alloc]init];
            
            //if(t_value < 0.001)
            if(t_value < 0.17)
            {
                down_color = self.ball_colors[0];
                up_color = self.ball_colors[1];
            }
            else if(t_value < 0.34)
            //else if(t_value < 0.01)
            {
                down_color = self.ball_colors[1];
                up_color = self.ball_colors[2];
            }
            else if(t_value < 0.5)
            //else if(t_value < 0.1)
            {
                down_color = self.ball_colors[2];
                up_color = self.ball_colors[3];
            }
            //else if(t_value < 0.15)
            else if(t_value < 0.68)
            {
                down_color = self.ball_colors[3];
                up_color = self.ball_colors[4];
            }
            else if(t_value < 0.85)
            {
                down_color = self.ball_colors[4];
                up_color = self.ball_colors[5];
            }
            else
            {
                down_color = self.ball_colors[5];
                up_color = self.ball_colors[6];
            }
            
            // set properties of sphere for rendering
            SPHNode *sphere_node = self.spheres[i];
            [sphere_node set_color:down_color with_peak_color:up_color with_amplitude:y_amplitude withDuration:ball_speed];
        }
    }
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"executionTime = %f", executionTime);
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

/*
 Sample data points from wavelength -> load into memory
 */
- (void)animate
{
    int NUM_SPHERES = 25;
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

//
// Creates an EZAudioFile from an MPMediaItem representing a song coming from
// an iOS device's iPod library. Since an MPMediaItem's URL is always prefixed
// with an ipod:// path we must use the AVAssetExportSession to first export
// the song to a file path that the EZAudioFile can actually find in the app's bundle.
//
- (void)openMediaItem:(MPMediaItem *)item
           completion:(void(^)(EZAudioFile *audioFile, NSError *error))completion
{
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
    if (url)
    {
        //
        // Create an AVAudioExportSession to export the MPMediaItem to a non-iPod
        // file path url we can actually use for an EZAudioFile
        //
        AVURLAsset *asset = [AVURLAsset assetWithURL:url];
        AVAssetExportSession *exporter = [AVAssetExportSession exportSessionWithAsset:asset
                                                                           presetName:AVAssetExportPresetAppleM4A];
        exporter.outputFileType = @"com.apple.m4a-audio";
        
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths objectAtIndex:0];
        
        NSString *exportURLPath = [documentPath stringByAppendingFormat:@"/%@.m4a", title];
        NSURL *exportURL = [NSURL fileURLWithPath:exportURLPath];
        exporter.outputURL = exportURL;
        
        //
        // Delete any existing path in the bundle if one already exists
        //
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:exportURLPath])
        {
            NSError *error;
            [fileManager removeItemAtPath:exportURLPath error:&error];
            if (error)
            {
                NSLog(@"error deleting file: %@", error.localizedDescription);
            }
        }
        
        //
        // Export the audio data using the AVAudioExportSession to the
        // exportURL in the application bundle
        //
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            AVAssetExportSessionStatus status = [exporter status];
            switch (status)
            {
                case AVAssetExportSessionStatusCompleted:
                {
                    EZAudioFile *_file = [EZAudioFile audioFileWithURL:exportURL];
                    completion(_file ,nil);
                    self.audio_file = _file;
                    
                    break;
                }
                case AVAssetExportSessionStatusFailed:
                {
                    completion(nil, exporter.error);
                    break;
                }
                default:
                {
                    NSLog(@"Exporter status not fialed or complete: %ld", status);
                    break;
                }
            }
            
        }];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:@"com.myapp.sha"
                                             code:404
                                         userInfo:@{ NSLocalizedDescriptionKey : @"Media item's URL not found" }];
        completion(nil, error);
    }
}

//------------------------------------------------------------------------------

@end
