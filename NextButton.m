//
//  NextButton.m
//  Practice
//
//  Created by Alex Harrison on 11/22/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NextButton.h"

@interface NextButton ()

@end

@implementation NextButton

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor whiteColor]setFill];
    
    // draw first triangle
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.5), rect.origin.y + (rect.size.height * 0.5))];
    [path addLineToPoint:CGPointMake(0.0, rect.origin.y + rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
    [path fill];
    
    // draw second triangle
    [path moveToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.5), rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + (rect.size.height * 0.5))];
    [path addLineToPoint:CGPointMake(rect.size.width * 0.5, rect.origin.y + rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.5), rect.origin.y)];
    [path fill];
}

@end
