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

@interface SongController : UIViewController

@property UISearchBar *search_bar;
@property UITableView *table_view;
@property NSMutableArray *songs_array;
@property int song_index;
@property NSMutableArray* queried_refs;
@property bool is_searching;

- (void)reset_state;

@end

