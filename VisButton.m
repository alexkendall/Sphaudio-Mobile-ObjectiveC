//
//  VisButton.m
//  SphaudioCore
//
//  Created by Alex Harrison on 12/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisButton.h"

@implementation VisButton

-(void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    // define first circle bounds
    CGFloat offset1y = self.start_y + (rect.size.height * 0.6);
    CGFloat offset1x = self.start_x + (rect.size.width * 0.1);
    CGFloat dim1 = rect.size.height * 0.35;
    UIBezierPath *circle1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(offset1x, offset1y, dim1, dim1)];
    
    // define second circle bounds
    CGFloat offset2x = (rect.size.width * 0.4) + self.start_x;
    CGFloat offset2y = rect.size.height * 0.45;
    CGFloat dim2 = dim1;
    UIBezierPath *circle2 =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(offset2x, offset2y, dim2, dim2)];
    
    // define third circle bounds
    CGFloat offset3x = (rect.size.width * 0.25) + self.start_x;
    CGFloat offset3y = (rect.size.height * 0.1);
    CGFloat dim3 = dim2;
    UIBezierPath *circle3 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(offset3x, offset3y, dim3, dim3)];
    
    // fill each circle
    if(self.selected)
    {
        UIColor *light_blue = [[UIColor alloc]initWithRed:0.0 green:233.0 / 255.0 blue:1.0 alpha:1.0];
        UIColor *red_orange = [[UIColor alloc]initWithRed:1.0 green:107.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
        UIColor *bright_red = [[UIColor alloc]initWithRed:1.0 green:23.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
        [light_blue setFill];
        [circle1 fill];
        [red_orange setFill];
        [circle2 fill];
        [bright_red setFill];
        [circle3 fill];
    }
    else
    {
        [self.deselected_color setFill];
        [circle1 fill];
        [circle2 fill];
        [circle3 fill];
    }
    
}

@end