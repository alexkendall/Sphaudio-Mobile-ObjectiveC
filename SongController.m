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
#import "AppDelegate.h"
#import "ViewController.h"
@import MediaPlayer;

@implementation SongController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    CGFloat nav_offset = self.view.frame.size.width * 0.175;
    CGFloat height = self.view.frame.size.height - nav_offset;
    self.view.frame = CGRectMake(0.0, nav_offset, self.view.frame.size.width, height);
    self.view.backgroundColor = [[UIColor alloc]initWithRed:0.12 green:0.12 blue:0.12 alpha:1.0];
    
    // configure search bar
    self.search_bar = [[UISearchBar alloc]init];
    CGFloat search_width = self.view.bounds.size.width;
    CGFloat search_height = 50.0;
    
    self.search_bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, search_width, search_height)];
    self.search_bar.delegate = self;
    [self.view addSubview:self.search_bar];
    
    // query songs from library
    self.songs_array = [MPMediaQuery songsQuery].items;
    self.is_searching = false;
    
    // configure table view
    UIColor *dark_gray = [[UIColor alloc]initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    CGFloat table_height = self.view.frame.size.height;
    self.table_view = [[UITableView alloc]initWithFrame:CGRectMake(0.0, search_height, self.view.frame.size.width, table_height) style:UITableViewStylePlain];
    self.table_view.delegate = self;
    self.table_view.dataSource = self;
    [self.view addSubview:self.table_view];
    self.table_view.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table_view.backgroundColor = dark_gray;
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}



#pragma mark - UITableViewDelegate

//------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("Selected row %ld\n", (long)indexPath.row);
    
    // get song
    MPMediaItem *selected_song = self.songs_array[indexPath.row];
    
    // generate collection
    MPMediaItemCollection *media_collection = [[MPMediaItemCollection alloc]initWithItems:@[selected_song]];
    
    // get visualizer controller instance and set playback of its player
    AppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
    ViewController *vis_controller = app_delegate.vis_controller;
    
    // get media player
    MPMusicPlayerController *media_player = vis_controller.media_player;
    [media_player setQueueWithItemCollection:media_collection];
    
    // play song
    vis_controller.current_song = selected_song;
    [vis_controller play];
    
    // get rid of keyboard if up
    [self.search_bar resignFirstResponder];
    
    // update song title
    [vis_controller setSongTitle:selected_song.title withArtist:selected_song.artist];
    
    // update seek time
    vis_controller.seek_time = 0.0;
}

//------------------------------------------------------------------------------

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *dark_gray = [[UIColor alloc]initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    UIColor *light_gray = [[UIColor alloc]initWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    MPMediaItem *media_item;
    
    // get media item
    if(self.is_searching)
    {
        media_item = self.queried_refs[indexPath.row];
        
    }
    else
    {
        media_item = self.songs_array[indexPath.row];
    }
    
    cell.textLabel.text = media_item.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if((indexPath.row % 2) == 0)
    {
        cell.backgroundColor = dark_gray;
    }
    else
    {
        cell.backgroundColor = light_gray;
    }
    return cell;
}

//------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    printf("%lu songs loaded from system library\n", (unsigned long)self.songs_array.count);
    
    if(self.is_searching)
    {
        printf("Setting music queue size to %lu [queried items]", (unsigned long)self.queried_refs.count);
        return self.queried_refs.count;
    }
    else
    {
        printf("Setting music queue size to %lu [regular queue]", (unsigned long)self.songs_array.count);
        return self.songs_array.count;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // reset queried reference array
     self.queried_refs = [[NSMutableArray alloc]init];
    
    // seaarch for songs with text specified -
    for(int i = 0; i < self.songs_array.count; ++i)
    {
        // convert all search fields to lowercase
        MPMediaItem *song = self.songs_array[i];
        NSString *artist = [song.artist lowercaseString];
        NSString *title = [song.title lowercaseString];
        NSString *search_text = [self.search_bar.text lowercaseString];
        
        // check if title or artist comes up in query, if does add result to set
        if(([title containsString:search_text]) || ([artist containsString:search_text]))
        {
            [self.queried_refs addObject:song];
        }
    }
    
    // must have at least one song to switch data source to queried songs
    if(self.queried_refs.count > 0)
    {
        self.is_searching = true;
    }
    else
    {
        self.is_searching = false;
    }
    
    [self.search_bar resignFirstResponder];
    [self.table_view reloadData];
    printf("queried items: %lu", (unsigned long)self.queried_refs.count);
}


- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    
    if([searchText length] == 0)
    {
        [self reset_state];
        [searchBar resignFirstResponder];
    }
}

#pragma mark - Utility

- (void)reset_state
{
    self.is_searching = false;
    self.search_bar.text = @"";
    [self.table_view reloadData];
}

@end