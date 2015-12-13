//
//  ViewController.m
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import "SettingsController.h"
#import <UIKit/UIKit.h>
#include "CheckButton.h"
#include "AppDelegate.h"

@implementation SettingsController

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *dark_gray = [[UIColor alloc]initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    self.view.backgroundColor = dark_gray;
    
    self.CURRENT_THEME = 0;
    
    // configure colors
    
    // default
    UIColor *light_blue = [[UIColor alloc]initWithRed:0.0 green:233.0 / 255.0 blue:1.0 alpha:1.0];
    UIColor *teal = [[UIColor alloc]initWithRed:0.0 green:159.0 / 255.0 blue:165.0 / 255.0 alpha:1.0];
    UIColor *soft_green = [[UIColor alloc]initWithRed:0.0 green:179.0 / 255.0 blue:97.0 / 255.0 alpha:1.0];
    UIColor *yellow_orange = [[UIColor alloc]initWithRed:1.0 green:198.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *red_orange = [[UIColor alloc]initWithRed:1.0 green:107.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *bright_red = [[UIColor alloc]initWithRed:1.0 green:23.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *dark_red = [[UIColor alloc]initWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];

    
    self.default_colors = @[light_blue, teal, soft_green, yellow_orange, red_orange, bright_red, dark_red];
    
    UIColor *white = [UIColor whiteColor];

    // warm
    UIColor *yellow = [UIColor yellowColor];
    UIColor *soft_yellow = [[UIColor alloc]initWithRed:1.0 green:212.0 / 255.0 blue:0.0 alpha:1.0];
    UIColor *burnt_yellow = [[UIColor alloc]initWithRed:1.0 green:150.0 / 255.0 blue:0.0 alpha:1.0];
    UIColor *soft_orange= [[UIColor alloc]initWithRed:1.0 green:68.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *soft_red = [[UIColor alloc]initWithRed:1.0 green:26.0 / 255.0 blue:0.0 alpha:1.0];
    UIColor *burnt_red = [[UIColor alloc]initWithRed:178.0 / 255.0 green:0.0 blue:0.0 alpha:1.0];
    UIColor *dark_maroon = [[UIColor alloc]initWithRed:109.0 / 255.0 green:0.0 blue:0.0 alpha:1.0];
    
    self.warm_colors = @[yellow, soft_yellow, burnt_yellow, soft_orange, soft_red, burnt_red, dark_red];
    
    // cool
    UIColor *icy_blue_ = [[UIColor alloc]initWithRed:0.0 green:255.0 / 255.0 blue:1.0 alpha:1.0];
    UIColor *light_blue_ = [[UIColor alloc]initWithRed:0.0 green:184.0 / 255.0 blue:225.0 / 255.0 alpha:1.0];
    UIColor *soft_blue_ = [[UIColor alloc]initWithRed:0.0 green:104.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    UIColor *soft_green_ = [[UIColor alloc]initWithRed:0.0 green:167.0 / 255.0 blue:123.0 alpha:1.0];
    UIColor *light_green_ = [[UIColor alloc]initWithRed:0.0 / 255.0 green:167.0 / 255.0 blue:66.0 / 255.0 alpha:1.0];
    UIColor *forest_green_ = [[UIColor alloc]initWithRed:0.0 / 255.0 green:167.0 / 255.0 blue:66.0 / 255.0 alpha:1.0];
    UIColor *dark_green_ = [[UIColor alloc]initWithRed:0.0 / 255.0 green:64.0 / 255.0 blue:25.0 / 255.0 alpha:1.0];
    self.cool_colors = @[icy_blue_, light_blue_, soft_blue_, soft_green_, light_green_, forest_green_, dark_green_];
    

    
    // settings theme
    CGFloat settings_margin = self.view.bounds.size.width * 0.05;
    self.settings_label = [[UILabel alloc]initWithFrame:CGRectMake(settings_margin, settings_margin, self.view.bounds.size.width, 30.0)];
    [self.view addSubview:self.settings_label];
    self.settings_label.text = @"SETTINGS";
    self.settings_label.textColor = [UIColor whiteColor];
    self.settings_label.font = [UIFont systemFontOfSize:23.0];
    
    // default theme
    CGFloat seperator_height = self.view.bounds.size.height * 0.125;
    self.default_label =     self.default_label = [[UILabel alloc]initWithFrame:CGRectMake(settings_margin, self.settings_label.frame.origin.y + seperator_height, self.view.bounds.size.width, 20.0)];
    self.default_label.textColor = [UIColor whiteColor];
    self.default_label.text = @"DEFAULT THEME";
    [self.view addSubview:self.default_label];
    
    // colors
    CGFloat span = self.view.bounds.size.width * 5.0 / 7.0;
    int NUM_COLORS = 6;
    CGFloat dim = span / 9.0;
    CGFloat margin = dim * 0.5;
    CGFloat offset_y = self.default_label.frame.origin.y + self.default_label.frame.size.height;
    self.default_views = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < NUM_COLORS; ++i)
    {
        CGFloat x = (margin * (i + 1)) + (dim * i);
        UIView *color_view = [[UIView alloc]initWithFrame:CGRectMake(x, offset_y + margin, dim, dim)];
        color_view.layer.borderWidth = 1.0;
        color_view.layer.borderColor = [[UIColor whiteColor] CGColor];
        color_view.backgroundColor = self.default_colors[i];
        [self.view addSubview:color_view];
        [self.default_views addObject:color_view];
        
    }
    
    // default selection view
    self.def_selection_but = [[CheckButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - dim - margin, offset_y + margin, dim, dim)];
    [self.def_selection_but setTag:0];
    [self.def_selection_but set_checked];
    [self.view addSubview:self.def_selection_but];
    [self.def_selection_but addTarget:self action:@selector(update_theme_with_sender:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // warm theme
    CGFloat warm_y = self.default_label.frame.origin.y +  self.default_label.frame.size.height + seperator_height;
    
    self.warm_theme = [[UILabel alloc]initWithFrame:CGRectMake(settings_margin, warm_y, self.view.bounds.size.width, 20.0)];
    self.warm_theme.text = @"WARM THEME";
    self.warm_theme.textColor = [UIColor whiteColor];
    [self.view addSubview:self.warm_theme];
    
    for(int i = 0; i < NUM_COLORS; ++i)
    {
        CGFloat x = (margin * (i + 1)) + (dim * i);
        UIView *color_view = [[UIView alloc]initWithFrame:CGRectMake(x, warm_y + 20.0 + margin, dim, dim)];
        color_view.layer.borderWidth = 1.0;
        color_view.layer.borderColor = [[UIColor whiteColor] CGColor];
        color_view.backgroundColor = self.warm_colors[i];
        [self.view addSubview:color_view];
    }
    
    // warm selection view
    self.warm_selection_but = [[CheckButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - dim - margin, warm_y + 20.0 + margin, dim, dim)];
    self.warm_selection_but.backgroundColor = [UIColor whiteColor];
    [self.warm_selection_but setTag:1];
    [self.view addSubview:self.warm_selection_but];
    [self.warm_selection_but addTarget:self action:@selector(update_theme_with_sender:) forControlEvents:UIControlEventTouchUpInside];
    
    // cool theme
    CGFloat cool_y = self.warm_theme.frame.origin.y +  self.warm_theme.frame.size.height + seperator_height;
    
    self.cool_theme = [[UILabel alloc]initWithFrame:CGRectMake(settings_margin, cool_y, self.view.bounds.size.width, 20.0)];
    self.cool_theme.text = @"COOL THEME";
    self.cool_theme.textColor = [UIColor whiteColor];
    [self.view addSubview:self.cool_theme];
    
    for(int i = 0; i < NUM_COLORS; ++i)
    {
        CGFloat x = (margin * (i + 1)) + (dim * i);
        UIView *color_view = [[UIView alloc]initWithFrame:CGRectMake(x, cool_y + 20.0 + margin, dim, dim)];
        color_view.layer.borderWidth = 1.0;
        color_view.layer.borderColor = [[UIColor whiteColor] CGColor];
        color_view.backgroundColor = self.cool_colors[i];
        [self.view addSubview:color_view];
    }
    
    // cool selection view
    self.cool_selection_but = [[CheckButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - dim - margin, cool_y + 20.0 + margin, dim, dim)];
    [self.view addSubview:self.cool_selection_but];
    [self.cool_selection_but setTag:2];
    [self.cool_selection_but addTarget:self action:@selector(update_theme_with_sender:) forControlEvents:UIControlEventTouchUpInside];
    
    // shininess label and switch
    CGFloat shininess_y = self.cool_theme.frame.origin.y +  self.cool_theme.frame.size.height + seperator_height;
    self.shininess_label = [[UILabel alloc]initWithFrame:CGRectMake(settings_margin, shininess_y, self.view.bounds.size.width, 20.0)];
    self.shininess_label.text = @"SHINNY MODE";
    
    //shinny_switch
    self.shininess_label.textColor = [UIColor whiteColor];
    self.shinny_switch = [[CheckButton alloc]initWithFrame:CGRectMake(settings_margin, shininess_y + 20.0 + margin, dim, dim)];
    [self.shinny_switch addTarget:self action:@selector(toggle_shinny_mode_with_sender:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shininess_label];
    [self.view addSubview:self.shinny_switch];
    
    // 5x5 label
    CGFloat five_y = self.shininess_label.frame.origin.y +  self.shininess_label.frame.size.height + seperator_height;
    self.five_label = [[UILabel alloc]initWithFrame:CGRectMake(settings_margin, five_y, self.view.bounds.size.width, 20.0)];
    [self.view addSubview:self.five_label];
    self.five_label.text = @"5 x 5";
    self.five_label.textColor = [UIColor whiteColor];
    
    // 5 X 5 switch
    self.five_switch = [[CheckButton alloc]initWithFrame:CGRectMake(settings_margin, five_y + 20.0 + margin, dim, dim)];
    [self.view addSubview:self.five_switch];
    [self.five_switch addTarget:self action:@selector(set_5x5) forControlEvents:UIControlEventTouchUpInside];
    
    // 7x7 label
    self.seven_label = [[UILabel alloc]initWithFrame:CGRectMake(settings_margin + 80.0, five_y, self.view.bounds.size.width, 20.0)];
    self.seven_label.text = @"7 x 7";
    self.seven_label.textColor = [UIColor whiteColor];
    [self.view addSubview:self.seven_label];
    
    // 7 X 7 switch
    self.seven_switch = [[CheckButton alloc]initWithFrame:CGRectMake(self.seven_label.frame.origin.x, self.five_switch.frame.origin.y, dim, dim)];
    [self.view addSubview:self.seven_switch];
    [self.seven_switch addTarget:self action:@selector(set_7x7) forControlEvents:UIControlEventTouchUpInside];
    
    // default
    [self set_7x7];
}

-(void)set_7x7
{
    [self.seven_switch set_checked];
    [self.five_switch set_not_checked];
    AppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
    ViewController *vis_controller = app_delegate.vis_controller;
    vis_controller.NUM_SPHERES = 49;
    [vis_controller load_spheres];
    
    // store persistently
    //store_num_spheres(49);
}

-(void)set_5x5
{
    [self.five_switch set_checked];
    [self.seven_switch set_not_checked];
    AppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
    ViewController *vis_controller = app_delegate.vis_controller;
    vis_controller.NUM_SPHERES = 25;
    [vis_controller load_spheres];
    
    // store persistently
    //store_num_spheres(25);
    
}

-(void)toggle_shinny_mode_with_sender:(CheckButton*)sender
{
    printf("toggling shinny mode");
    if(sender.is_checked)
    {
        [sender set_not_checked];
        AppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
        ViewController *vis_controller = app_delegate.vis_controller;
        [vis_controller set_matte];
    }
    else
    {
        [sender set_checked];
        AppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
        ViewController *vis_controller = app_delegate.vis_controller;
        [vis_controller set_shinny];
    }
}

-(void) update_theme_with_sender:(UIButton*)sender
{
    printf("Theme selected for button number %ld\n", (long)sender.tag);
    
    [self set_theme:(int)sender.tag];
}

-(void) set_theme:(int)num
{
    AppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
    ViewController *visualizer_controller = app_delegate.vis_controller;
    if(num == 0)
    {
        [self.def_selection_but set_checked];
        [self.warm_selection_but set_not_checked];
        [self.cool_selection_but set_not_checked];
        visualizer_controller.ball_colors = self.default_colors;
    }
    if(num == 1)
    {
        [self.def_selection_but set_not_checked];
        [self.warm_selection_but set_checked];
        [self.cool_selection_but set_not_checked];
        visualizer_controller.ball_colors = self.warm_colors;
    }
    if(num == 2)
    {
        [self.def_selection_but set_not_checked];
        [self.warm_selection_but set_not_checked];
        [self.cool_selection_but set_checked];
        visualizer_controller.ball_colors = self.cool_colors;
    }

}

@end