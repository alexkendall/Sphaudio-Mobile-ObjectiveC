
//
//  AppDelegate.h
//  Practice
//
//  Created by Alex Harrison on 11/21/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#include "SongController.h"
#include "SettingsController.h"
#include "ViewController.h"
#include "Device.h"
@import MediaPlayer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property SongController* songs_controller;
@property ViewController* vis_controller;
@property SettingsController* settings_controller;
@property UITabBarController *tab_controller;

@property int shinny_mode;
@property int num_spheres;
@property int theme;
@property bool was_playing;
@property Device device;
@property MPMusicPlayerController *background_player;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end