//
//  NextButton.m
//  Practice
//
//  Created by Alex Harrison on 11/22/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavBar.h"

@interface NavBar ()

@end

@implementation NavBar

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor whiteColor]setStroke];
    path.lineWidth = 2.0;
    
    if(self.is_toggled)
    {
        path.lineWidth = 4.0;
    }
    else
    {
        path.lineWidth = 2.0;
    }
    
    // draw first line
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + 2.0)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + 2.0)];
    [path stroke];
    
    // draw second line
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + (rect.size.height * 0.5))];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + (rect.size.height * 0.5))];
    [path stroke];
    
    // draw third line
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - 2.0)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - 2.0)];
    [path stroke];
}

-(void)toggle
{
    if(self.is_toggled)
    {
        self.is_toggled = false;
        [self setNeedsDisplay];
    }
    else
    {
        self.is_toggled = true;
        [self setNeedsDisplay];
    }
}

@end
