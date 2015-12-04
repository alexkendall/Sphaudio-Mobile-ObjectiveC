//
//  PlayButton.h
//  Practice
//
//  Created by Alex Harrison on 11/22/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface CheckButton : UIButton

@property bool is_checked;

-(void)set_checked;

-(void)set_not_checked;

@end