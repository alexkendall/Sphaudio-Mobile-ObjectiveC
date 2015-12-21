//
//  NextButton.m
//  Practice
//
//  Created by Alex Harrison on 11/22/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckButton.h"

@interface CheckButton ()

@end

@implementation CheckButton


// set checked off by default
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.is_checked = false;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.is_checked = false;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    if(self.is_checked)
    {
        [[UIColor blackColor]setStroke];
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path setLineWidth:3.0];
        [path moveToPoint:CGPointMake(rect.size.width * 0.1, rect.size.height * 0.6)];
        [path addLineToPoint:CGPointMake(rect.size.width * 0.45, rect.size.height * 0.9)];
        [path addLineToPoint:CGPointMake(rect.size.width * 0.9, rect.size.height * 0.1)];
        [path stroke];
    }
}

-(void)set_checked
{
    self.is_checked = true;
    [self setNeedsDisplay];
}

-(void)set_not_checked
{
    self.is_checked = false;
    [self setNeedsDisplay];
}

@end
