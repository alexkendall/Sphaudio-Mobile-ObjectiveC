//
//  Core.m
//  Practice
//
//  Created by Alex Harrison on 12/13/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Core.h"
#include "AppDelegate.h"
#include <stdio.h>

//-----------------------------------------------------------------------------------------

void save_context()
{
    printf("Saving current context\n");
    AppDelegate *app_delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managed_context = app_delegate.managedObjectContext;
    NSError *error = nil;
    [managed_context save:&error];
}

//-----------------------------------------------------------------------------------------

NSManagedObject* fetch_settings()
{
    NSManagedObject *settings_data;
    
    AppDelegate *app_delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managed_context = app_delegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Settings"];
    NSError *error = nil;
    
    NSArray *results = [managed_context executeFetchRequest:request error:&error];
    if(results.count == 0)
    {
        // set default settings on first save
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managed_context];
        NSManagedObject *settings_data = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:managed_context];
        [settings_data setValue:[NSNumber numberWithInt:0] forKey:@"theme"];
        [settings_data setValue:false forKey:@"shinny_mode"];
        [settings_data setValue:[NSNumber numberWithInt:49] forKey:@"num_spheres"];
        
         save_context();
        
    }
    else
    {
        settings_data = results[0];
    }
    return settings_data;
}

//-----------------------------------------------------------------------------------------

void store_theme(int theme)
{
    AppDelegate *app_delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managed_context = app_delegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managed_context];
    NSManagedObject *settings_data = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:managed_context];
    [settings_data setValue:[NSNumber numberWithInt:theme] forKey:@"theme"];
    
    save_context();
    
}

//-----------------------------------------------------------------------------------------

void store_num_spheres(int num_spheres)
{
    AppDelegate *app_delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managed_context = app_delegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managed_context];
    NSManagedObject *settings_data = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:managed_context];
    [settings_data setValue:[NSNumber numberWithInt:num_spheres] forKey:@"num_spheres"];
    
    save_context();
}

//-----------------------------------------------------------------------------------------

void store_mode(bool is_shinny)
{
    AppDelegate *app_delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managed_context = app_delegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managed_context];
    NSManagedObject *settings_data = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:managed_context];
    [settings_data setValue:[NSNumber numberWithBool:is_shinny] forKey:@"num_spheres"];
    
    save_context();
}

//-----------------------------------------------------------------------------------------

int get_theme()
{
    NSManagedObject *settings_data = fetch_settings();
    int theme = (int)[settings_data valueForKey:@"theme"];
    return theme;
}

//-----------------------------------------------------------------------------------------

int get_num_spheres()
{
    NSManagedObject *settings_data = fetch_settings();
    int num_spheres = (int)[settings_data valueForKey:@"num_spheres"];
    return num_spheres;
}

//-----------------------------------------------------------------------------------------

bool get_shinny_mode()
{
    NSManagedObject *settings_data = fetch_settings();
    bool is_shinny = (bool)[settings_data valueForKey:@"shinny_mode"];
    return is_shinny;
}


