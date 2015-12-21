//
//  TabButton.h
//  SphaudioCore
//
//  Created by Alex Harrison on 12/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

@import UIKit;

@interface SPHTabButton : UIButton

@property bool is_selected;
@property UIColor *highlight_color;
@property UIColor *deselected_color;
@property CGFloat start_x;
@property CGFloat start_y;

-(void)set_highlight_color:(UIColor *)highlight_color;

-(void)set_deselected_color:(UIColor *)deselected_color;

-(void)deselect;

-(void)highlight;
@end

