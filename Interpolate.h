//
//  ViewController.h
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>


UIColor* interpolate_helper(float t_value, UIColor *color1, UIColor *color2);

void interpolate(float t_value, NSArray *colors, UIColor *up_color, UIColor *down_color);
