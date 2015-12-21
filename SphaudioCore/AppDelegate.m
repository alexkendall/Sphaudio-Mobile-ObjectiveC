//
//  AppDelegate.m
//  SphaudioCore
//
//  Created by Alex Harrison on 12/18/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import "AppDelegate.h"
#import "Icon.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*
    self.tab_controller = [[UITabBarController alloc]init];
    
    // create view controller and corresponding tab bar images
    
    CGRect image_size = CGRectMake(0.0, 0.0,30.0, 30.0);
    UIImage *sphaudio_image = get_sphaudio_icon(&image_size);
    
    UIImage *tab_image1 = [UIImage imageNamed:@"music.png"];
    UIImage *tab_image2 = [UIImage imageNamed:@"pulse.png"];
    UIImage *tab_image3 = [UIImage imageNamed:@"set.png"];
    
    self.songs_controller = [[SongController alloc]init];
    self.songs_controller.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Music" image:tab_image1 tag:0];
    
    self.vis_controller = [[ViewController alloc]init];
    self.vis_controller.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Visualizer" image:sphaudio_image tag:1];
    
    self.settings_controller = [[SettingsController alloc]init];
    self.settings_controller.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Settings" image:tab_image3 tag:2];
    
    self.tab_controller.viewControllers = @[self.songs_controller, self.vis_controller, self.settings_controller];
    self.tab_controller.selectedViewController = self.vis_controller;
    self.window.rootViewController = self.tab_controller;
    
    self.tab_controller.tabBar.tintColor =  [UIColor whiteColor];
    [self.tab_controller.tabBar setBackgroundColor:[UIColor blackColor]];
    [self.tab_controller.tabBar setTranslucent:NO];
    self.tab_controller.tabBar.backgroundColor = [UIColor blackColor];
    self.tab_controller.tabBar.barStyle = UIBarStyleBlack;
    self.tab_controller.delegate = self;
    
    // hide status bar
    application.statusBarHidden = YES;
    
    self.background_player = [[MPMusicPlayerController alloc]init];
    */
    
    self.root_controller = [[SPHTabBarController alloc]init];
    self.window.rootViewController = self.root_controller;
    
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(viewController == self.songs_controller)
    {
        printf("Song controller selected\n");
        
    }
    else if (viewController == self.vis_controller)
    {
        printf("Visualizer controller selected\n");
        [self.songs_controller reset_state];
    }
    else
    {
        printf("Settings controller selected\n");
        [self.songs_controller reset_state];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    
    // if song is playing, switch players to ipods player once app goes to background such that it continues playing current song
    
    if(self.vis_controller.playing)
    {
        MPMediaItem *item = self.songs_controller.songs_array[self.songs_controller.song_index];
        MPMediaItemCollection *item_collection = [[MPMediaItemCollection alloc]initWithItems:@[item]];
        [self.background_player setQueueWithItemCollection:item_collection];

        // seek to correct time
        NSTimeInterval current_time = self.vis_controller.player.currentTime;
        self.background_player.currentPlaybackTime = current_time;
    
        [self.vis_controller pause];
        [self.background_player play];
        self.was_playing = true;
    }
    else
    {
        self.was_playing = false;
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
        // get current playing song and time to seek to
        NSTimeInterval current_time = self.background_player.currentPlaybackTime;
        MPMediaItem* current_item = self.background_player.nowPlayingItem;
        NSURL *url = [current_item valueForKey:MPMediaItemPropertyAssetURL];
        self.vis_controller.audio_file = [[EZAudioFile alloc]initWithURL:url];
        self.vis_controller.player.audioFile = self.vis_controller.audio_file;
    
        // update song labels
        [self.vis_controller setSongTitle:current_item.title withArtist:current_item.artist];
    
        // seek to correspoding part of song
        self.vis_controller.seek_slider.maximumValue = self.vis_controller.audio_file.duration;
        self.vis_controller.seek_slider.value = current_time;
        [self.vis_controller manual_seek];
        
        // get and set current song index
        NSMutableArray *songs_array = self.songs_controller.songs_array;
        NSURL *song_url = [current_item valueForKey:MPMediaItemPropertyAssetURL];
        int song_index = -1;
        for(int i = 0; i < self.songs_controller.songs_array.count; ++i)
        {
            NSURL *cur_url = [songs_array[i] valueForKey:MPMediaItemPropertyAssetURL];
            if(cur_url == song_url)
            {
                song_index = i;
                break;
            }
        }
        self.songs_controller.song_index = song_index;
        [self.background_player pause];
    
        if(self.was_playing)
        {
            [self.vis_controller play];
        }
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.alexkendall.SphaudioCore" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SphaudioCore" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SphaudioCore.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
