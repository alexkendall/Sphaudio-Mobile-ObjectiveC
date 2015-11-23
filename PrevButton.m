//
//  NextButton.m
//  Practice
//
//  Created by Alex Harrison on 11/22/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrevButton.h"

@interface PrevButton ()

@end

@implementation PrevButton

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor whiteColor]setFill];
    
    // draw first triangle
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + (rect.size.height * 0.5))];
    [path addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.5), rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.5), rect.origin.y + rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + (rect.size.height * 0.5))];
    [path fill];
    
    // draw second triangle
    [path moveToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.5), rect.origin.y + (rect.size.height * 0.5))];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, 0.0)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.5), rect.origin.y + (rect.size.height * 0.5))];
    [path fill];
}

@end
