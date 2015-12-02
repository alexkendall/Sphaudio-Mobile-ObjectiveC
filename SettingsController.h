//
//  ViewController.h
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController

@property UILabel *settings_label;
@property UILabel *default_label;
@property UILabel *warm_theme;
@property UILabel *cool_theme;
@property NSArray *default_colors;
@property NSArray *warm_colors;
@property NSArray *cool_colors;

@end

