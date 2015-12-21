//
//  SPHNode.m
//  Practice
//
//  Created by Alex Harrison on 11/29/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPHNode.h"

@implementation SPHNode

-(void)set_color:(UIColor *)color with_peak_color:(UIColor*)peak_color with_amplitude:(float)amplitude withDuration:(NSTimeInterval)duration
{
    self.down_color = color;
    self.up_color = peak_color;
    self.amplitude = amplitude;
    self.duration = duration;
    
    // set material properties
    if(self.geometry.materials != nil)
    {
        SCNMaterial *material = self.geometry.materials[0];
        material.diffuse.contents = self.down_color;
    }
    else
    {
        SCNMaterial *material = [[SCNMaterial alloc]init];
        material.diffuse.contents = self.down_color;
        self.geometry.materials = @[material];
    }
}

@end