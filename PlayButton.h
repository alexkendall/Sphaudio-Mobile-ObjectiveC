//
//  PlayButton.h
//  Practice
//
//  Created by Alex Harrison on 11/22/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PlayButton : UIButton

@property bool *is_playing;
@property UIBezierPath *path;

-(void)set_paused;
-(void)set_playing;
-(void)toggle_play;

@end