//
//  PlayButton.m
//  Practice
//
//  Created by Alex Harrison on 11/22/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlayButton.h"

@interface PlayButton ()

@end

@implementation PlayButton

- (instancetype)init
{
    self = [super init];
    if (self) {
         [self addTarget:self action:@selector(toggle_play) forControlEvents:UIControlEventTouchUpInside];
        return self;
    }
    [self addTarget:self action:@selector(toggle_play) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // set path fill color to black
    [[UIColor whiteColor]setFill];
    self.path = [UIBezierPath bezierPath];
    self.path.lineWidth = 1.0;
    
    // draw play button
    if(self.is_playing)
    {
        [self.path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
        [self.path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + (rect.size.height * 0.5))];
        [self.path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)];
        [self.path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
        [self.path fill];
    }
    else
    {
        [[UIColor whiteColor]setStroke];
        self.path.lineWidth = 8.0;
        
        // draw first pause line
        [self.path moveToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.2), rect.origin.y)];
        [self.path addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.2), rect.origin.y + rect.size.height)];
        
        // draw second pause line
        [self.path moveToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.8), rect.origin.y)];
        [self.path addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width * 0.8), rect.origin.y + rect.size.height)];
        [self.path stroke];
    }
}

-(void)set_paused
{
    self.is_playing = false;
    [self setNeedsDisplay];
}

-(void) set_playing
{
    self.is_playing = true;
    [self setNeedsDisplay];
}

-(void)toggle_play
{
    printf("Toggling play button");
    if(self.is_playing)
    {
        [self set_paused];
    }
    else
    {
        [self set_playing];
    }
}

@end