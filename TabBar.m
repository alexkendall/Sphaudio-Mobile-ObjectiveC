//
//  TabBar.m
//  SphaudioCore
//
//  Created by Alex Harrison on 12/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "TabBar.h"

@implementation SPHTabBarController

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.vis_controller = [[ViewController alloc]init];
    self.settings_controller = [[SettingsController alloc]init];
    self.songs_controller = [[SongController alloc]init];
    
    CGFloat tab_height = 50.0;
    int num_buttons = 3;
    CGFloat width = self.view.frame.size.width / (CGFloat)num_buttons;
    for(int i = 0; i < 3; ++i)
    {
        CGFloat offset_x = width * i;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(offset_x, self.view.frame.size.height - tab_height, width, tab_height)];
        if(i == 0)
        {
            [button addTarget:self action:@selector(HandleMusic) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor yellowColor];
        }
        else if(i == 1)
        {
            [button addTarget:self action:@selector(HandleVisualizer) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor orangeColor];
        }
        else
        {
            [button addTarget:self action:@selector(HandleSettings) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor redColor];
        }
        [self.view addSubview:button];
    }
    
    // load visulaizer
    [self HandleVisualizer];
}

-(void)HandleMusic
{
    printf("Handling Music\n");
    [self.vis_controller.view removeFromSuperview];
    [self.settings_controller.view removeFromSuperview];
    [self.view addSubview: self.songs_controller.view];
}

-(void)HandleVisualizer
{
    printf("Handling Visualizer\n");
    [self.songs_controller.view removeFromSuperview];
    [self.settings_controller.view removeFromSuperview];
    [self.view addSubview: self.vis_controller.view];
}

-(void)HandleSettings
{
    printf("Handling Settings\n");
    [self.vis_controller.view removeFromSuperview];
    [self.songs_controller.view removeFromSuperview];
    [self.view addSubview: self.settings_controller.view];
}

-(void)drawRect:(CGRect)rect
{
    
}

@end
