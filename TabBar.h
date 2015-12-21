//
//  TabBar.h
//  SphaudioCore
//
//  Created by Alex Harrison on 12/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#ifndef TabBar_h
#define TabBar_h
@import UIKit;
#import "ViewController.h"
#import "SettingsController.h"
#import "SongController.h"

@interface SPHTabBarController : UIViewController

@property ViewController *vis_controller;
@property SettingsController *settings_controller;
@property SongController *songs_controller;

// properties
@property NSMutableArray *buttons;

// event handlers
-(void)HandleMusic;
-(void)HandleVisualizer;
-(void)HandleSettings;

@end

#endif
