//
//  TabButton.m
//  SphaudioCore
//
//  Created by Alex Harrison on 12/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "TabButton.h"


@implementation SPHTabButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.selected = false;
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    
    
    // ensure we draw in a square region
    if(height < width)
    {
        width = height;
    }
    
    self.start_x = (rect.size.width - width) * 0.25;
    self.start_y = (rect.size.height - height) * 0.25;
}

-(void)set_highlight_color:(UIColor *)highlight_color
{
    self.highlight_color = highlight_color;
    [self setNeedsDisplay];
}

-(void)set_deselected_color:(UIColor *)deselected_color
{
    self.deselected_color = deselected_color;
    [self setNeedsDisplay];
}

-(void)deselect
{
    self.selected = false;
    [self setNeedsDisplay];
}

-(void)highlight
{
    self.selected = true;
    [self setNeedsDisplay];
}

@end
