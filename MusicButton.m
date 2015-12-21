//
//  VisButton.m
//  SphaudioCore
//
//  Created by Alex Harrison on 12/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicButton.h"

@implementation MusicButton

-(void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(rect.size.width * 0.2, rect.size.height * 0.8)];
    [path addLineToPoint:CGPointMake(rect.size.width * 0.25, rect.size.height * 0.2)];
    [path addLineToPoint:CGPointMake(rect.size.width * 0.55, rect.size.height * 0.2)];
    [path addLineToPoint:CGPointMake(rect.size.width * 0.5, rect.size.height * 0.8)];
    path.lineWidth = 2.0;
    
    if(self.selected)
    {
        [self.highlight_color setStroke];
        [self.highlight_color setFill];
    }
    else
    {
        [self.deselected_color setStroke];
        [self.deselected_color setFill];
    }
    [path stroke];
    
    CGFloat circle_dim = 15.0;
    CGFloat circle_x = rect.size.height * 0.225;
    CGFloat circle_y = rect.size.height * 0.7;
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(circle_x, circle_y, circle_dim, circle_dim * 0.75)];
    [path fill];
    
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(circle_x + rect.size.width * 0.3, circle_y, circle_dim, circle_dim * 0.75)];
    [path fill];
}

@end