//
//  AppDelegate.h
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SceneKit;

@interface SPHNode: SCNNode

@property UIColor *up_color;
@property UIColor *down_color;
@property float amplitude;
@property float duration;

-(void)set_color:(UIColor *)color with_peak_color:(UIColor*)peak_color with_amplitude:(float)amplitude withDuration:(NSTimeInterval)duration;


@end

