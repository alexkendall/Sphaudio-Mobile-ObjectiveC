//
//  ViewController.h
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>


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


UIColor* interpolate(float t_value, NSMutableArray *colors)
{
    long long NUM_COLORS = colors.count;
    int cool_index = floorf(NUM_COLORS * t_value);
    int warm_index = cool_index + 1;
    
    // prevent from interpolating out of bounds
    if(cool_index == NUM_COLORS)
    {
        warm_index = cool_index;
    }
    
    // get cool and warm colors to interpolate between
    UIColor *cool_color = colors[cool_index];
    UIColor *warm_color = colors[warm_index];
    
    // clamp t value
    t_value -= cool_index;
    
    // get color between the two
    return interpolate_helper(t_value, cool_color, warm_color);
}