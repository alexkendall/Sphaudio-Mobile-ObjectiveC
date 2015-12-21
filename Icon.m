//
//  Icon.m
//  SphaudioCore
//
//  Created by Alex Harrison on 12/20/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "Icon.h"

UIImage *get_sphaudio_icon(CGRect *bounds)
{
    // begin context
    UIGraphicsBeginImageContext(bounds->size);
    
    // define first circle bounds
    CGFloat offset1y = 0.0;
    CGFloat offset1x = 0.0;
    CGFloat dim1 = bounds->size.height * 0.4;
    UIBezierPath *circle1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(offset1x, offset1y, dim1, dim1)];
    
    // define second circle bounds
    CGFloat offset2x = bounds->size.width * 0.5;
    CGFloat offset2y = 0.0;
    CGFloat dim2 = dim1;
    UIBezierPath *circle2 =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(offset2x, offset2y, dim2, dim2)];
    
    // define third circle bounds
    CGFloat offset3x = bounds->size.width * 0.25;
    CGFloat offset3y = bounds->size.height * 0.5;
    CGFloat dim3 = dim2;
    UIBezierPath *circle3 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(offset3x, offset3y, dim3, dim3)];
    
    // fill each circle
    [[UIColor whiteColor]setFill];
    [circle1 fill];
    [circle2 fill];
    [circle3 fill];
    
    // get result
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return result;
}
