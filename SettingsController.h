//
//  ViewController.h
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckButton.h"
@interface SettingsController : UIViewController

@property UILabel *settings_label;
@property UILabel *default_label;
@property UILabel *warm_theme;
@property UILabel *cool_theme;
@property NSArray *default_colors;
@property NSArray *warm_colors;
@property NSArray *cool_colors;
@property NSMutableArray *default_views;
@property NSMutableArray *cool_views;
@property NSMutableArray *warm_views;
@property int CURRENT_THEME;
@property CheckButton* cool_selection_but;
@property CheckButton* warm_selection_but;
@property CheckButton* def_selection_but;
@property CheckButton *shinny_switch;
@property CheckButton *five_switch;
@property CheckButton *seven_switch;
@property UILabel* shininess_label;
@property UILabel* seven_label;
@property UILabel* five_label;
@end

 