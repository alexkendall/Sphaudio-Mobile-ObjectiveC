//
//  interpolate.m
//  Practice
//
//  Created by Alex Harrison on 11/25/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Interpolate.h"



UIColor* interpolate_helper(float t_value, UIColor *color1, UIColor *color2)
{
    CGFloat red, green, blue, alpha, red2, green2, blue2, red_r, green_r, blue_r;
    [color1 getRed:&red green:&green blue:&blue alpha:&alpha];
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha];
    
    // get results
    red_r = ((1.0 - t_value) * red) + (t_value * red2);
    green_r = ((1.0 - t_value) * green) + (t_value * green2);
    blue_r = ((1.0 - t_value) * blue) + (t_value * blue2);
    
    return [[UIColor alloc]initWithRed:red_r green:green_r blue:blue_r alpha:1.0];
}


void interpolate(float t_value, NSArray *colors, UIColor *up_color, UIColor *down_color)
{
    UIColor *light_blue = [[UIColor alloc]initWithRed:0.0 green:233.0 / 255.0 blue:1.0 alpha:1.0];
    UIColor *teal = [[UIColor alloc]initWithRed:0.0 green:159.0 / 255.0 blue:165.0 / 255.0 alpha:1.0];
    UIColor *soft_green = [[UIColor alloc]initWithRed:0.0 green:179.0 / 255.0 blue:97.0 / 255.0 alpha:1.0];
    UIColor *yellow_orange = [[UIColor alloc]initWithRed:1.0 green:198.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *red_orange = [[UIColor alloc]initWithRed:1.0 green:107.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *bright_red = [[UIColor alloc]initWithRed:1.0 green:23.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    UIColor *white = [[UIColor alloc]initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
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
        up_color = white;
    }
    
}