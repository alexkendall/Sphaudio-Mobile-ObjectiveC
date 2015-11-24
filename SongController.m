//
//  ViewController.h
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudioFile.h"
#import "EZAudioPlayer.h"
#import "EZAudio.h"
#import "SongController.h"

@implementation SongController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    CGFloat nav_offset = self.view.frame.size.width * 0.175;
    CGFloat height = self.view.frame.size.height - nav_offset;
    self.view.frame = CGRectMake(0.0, nav_offset, self.view.frame.size.width, height);
    self.view.backgroundColor = [[UIColor alloc]initWithRed:0.12 green:0.12 blue:0.12 alpha:1.0];
    
    /*
     // configure search bar
     let search_width:CGFloat = super_view.bounds.width;
     let search_height:CGFloat = 50.0;
     search_bar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: search_width, height: search_height));
     search_bar.delegate = self;
     super_view.addSubview(search_bar)
     */
    
    // configure search bar
    self.search_bar = [[UISearchBar alloc]init];
    CGFloat search_width = self.view.bounds.size.width;
    CGFloat search_height = 50.0;
    self.search_bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, search_width, search_height)];
    self.search_bar.delegate = self;
    [self.view addSubview:self.search_bar];
    
    // configure table view
    CGFloat table_height = self.view.frame.size.height - search_height;
    self.table_view = [[UITableView alloc]initWithFrame:CGRectMake(0.0, search_height, self.view.frame.size.width, table_height)];
    self.table_view.delegate = self;
    [self.view addSubview:self.table_view];
}


@end