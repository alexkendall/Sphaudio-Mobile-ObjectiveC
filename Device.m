//
//  Device.m
//  SphaudioCore
//
//  Created by Alex Harrison on 12/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"
#import "AppDelegate.h"

Device getDeviceInfo()
{
    AppDelegate *app_delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *main_window = app_delegate.window;
    
    // get window dimensions
    CGFloat height = main_window.frame.size.height;
    CGFloat width = main_window.frame.size.width;
    
    if(height <= 480.0)
    {
        printf("\niPhone 4, Device Height: %f\nDevice Width: %f\n", height, width);
        return iPhone4;
    }
    else if(height <= 568.0)
    {
        printf("\niPhone 5, Device Height: %f\nDevice Width: %f\n", height, width);
        return iPhone5;
    }
    else if(height <= 667.0)
    {
        printf("\niPhone 6, Device Height: %f\nDevice Width: %f\n", height, width);
        return iPhone6;
    }
    else if(height <= 736)
    {
        printf("\niPhone 6 Plus, Device Height: %f\nDevice Width: %f\n", height, width);
        return iPhone6Plus;
    }
    else
    {
        printf("\niPad, Device Height: %f\nDevice Width: %f\n", height, width);
        return iPad;
    }
    return iPad;
}