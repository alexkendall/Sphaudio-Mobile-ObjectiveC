//
//  ViewController.m
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import "SettingsController.h"
#import <UIKit/UIKit.h>

@implementation SettingsController

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *dark_gray = [[UIColor alloc]initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    self.view.backgroundColor = dark_gray;
    
    
    // configure colors
    
    // default
    UIColor *light_blue = [[UIColor alloc]initWithRed:0.0 green:213.0 / 255.0 blue:1.0 alpha:1.0];
    UIColor *soft_blue = [[UIColor alloc]initWithRed:0.0 green:114.0 / 255.0 blue:228.0 / 255.0 alpha:1.0];
    UIColor *soft_green= [[UIColor alloc]initWithRed:0.0 green:198.0 / 255.0 blue:137.0 / 255.0 alpha:1.0];
    UIColor *gold = [[UIColor alloc]initWithRed:1.0 green:187.0 / 255.0 blue:0.0 alpha:1.0];
    UIColor *orange = [UIColor orangeColor];
    UIColor *red = [UIColor redColor];
    
    // warm
    UIColor *soft_yellow = [[UIColor alloc]initWithRed:1.0 green:212.0 / 255.0 blue:0.0 alpha:1.0];
    UIColor *burnt_yellow = [[UIColor alloc]initWithRed:1.0 green:150.0 / 255.0 blue:0.0 alpha:1.0];
    UIColor *soft_orange= [[UIColor alloc]initWithRed:1.0 green:68.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *soft_red = [[UIColor alloc]initWithRed:1.0 green:26.0 / 255.0 blue:0.0 alpha:1.0];
    UIColor *burnt_red = [[UIColor alloc]initWithRed:178.0 / 255.0 green:0.0 blue:0.0 alpha:1.0];
    UIColor *dark_maroon = [[UIColor alloc]initWithRed:109.0 / 255.0 green:0.0 blue:0.0 alpha:1.0];
    self.warm_colors = @[soft_yellow, burnt_yellow, soft_orange, soft_red, burnt_red, dark_maroon];
    
    // cool
    UIColor *icy_blue_ = [[UIColor alloc]initWithRed:0.0 green:255.0 / 255.0 blue:1.0 alpha:1.0];
    UIColor *light_blue_ = [[UIColor alloc]initWithRed:0.0 green:184.0 / 255.0 blue:225.0 / 255.0 alpha:1.0];
    UIColor *soft_blue_ = [[UIColor alloc]initWithRed:0.0 green:104.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    UIColor *soft_green_ = [[UIColor alloc]initWithRed:0.0 green:167.0 / 255.0 blue:123.0 alpha:1.0];
    UIColor *light_green_ = [[UIColor alloc]initWithRed:0.0 / 255.0 green:167.0 / 255.0 blue:66.0 / 255.0 alpha:1.0];
    UIColor *forest_green_ = [[UIColor alloc]initWithRed:0.0 / 255.0 green:167.0 / 255.0 blue:66.0 / 255.0 alpha:1.0];
    self.cool_colors = @[icy_blue_, light_blue_, soft_blue_, soft_green_, light_green_, forest_green_, dark_maroon];
    
    self.default_colors = @[light_blue, soft_blue, soft_green, gold, orange, red];
    
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
    
    for(int i = 0; i < NUM_COLORS; ++i)
    {
        CGFloat x = (margin * (i + 1)) + (dim * i);
        UIView *color_view = [[UIView alloc]initWithFrame:CGRectMake(x, offset_y + margin, dim, dim)];
        color_view.layer.borderWidth = 1.0;
        color_view.layer.borderColor = [[UIColor whiteColor] CGColor];
        color_view.backgroundColor = self.default_colors[i];
        [self.view addSubview:color_view];
    }
    
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
    
}

@end





