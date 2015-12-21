//
//  Core.m
//  Practice
//
//  Created by Alex Harrison on 12/13/15.
//  Copyright © 2015 Alex Harrison. All rights reserved.
//
#import <Foundation/Foundation.h>
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
    
    if (![managed_context save:&error]) {
        // Handle the error.
        
        printf("ERROR SAVING MANAGED OBJECT CONTEXT!\n");
    }
    
    print_settings();

}

//-----------------------------------------------------------------------------------------
// Utility
//-----------------------------------------------------------------------------------------
void print_settings()
{
    NSManagedObject *settings_data;
    
    AppDelegate *app_delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managed_context = [app_delegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Settings"];
    NSError *error = nil;
    
    NSArray *results = [managed_context executeFetchRequest:request error:&error];
    if(results.count > 0)
    {
        settings_data = results[0];
        NSString *num_spheres = [settings_data valueForKey:@"num_spheres"];
        NSString *shinny_mode = [settings_data valueForKey:@"shinny_mode"];
        NSString *theme = [settings_data valueForKey:@"theme"];
        printf("\nSettings\nShinnyMode: %s\nTheme: %s\nNum of spheres:%s \n", shinny_mode.UTF8String, theme.UTF8String, num_spheres.UTF8String);
    }
    else
    {
        printf("Error, unable to print and fetch settings\n");
    }
}

//-----------------------------------------------------------------------------------------

void delete_settings()
{
    // delete old dettings
    NSManagedObject *settings_data;
    
    AppDelegate *app_delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managed_context = [app_delegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Settings"];
    NSError *error = nil;
    
    NSArray *results = [managed_context executeFetchRequest:request error:&error];
    for(int i = 0; i < results.count; ++i)
    {
        settings_data = results[i];
        [managed_context deleteObject:settings_data];
    }
    save_context();
}

//-----------------------------------------------------------------------------------------

void store_settings(NSString *num_spheres, NSString *theme, NSString *shinny_mode)
{
    // delete previous settings if they're there
    delete_settings();
    
    // get context
    AppDelegate *app_delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managed_context = [app_delegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managed_context];
    NSManagedObject *settings_data = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:managed_context];
    
    
    [settings_data setValue:theme forKey:@"theme"];
    [settings_data setValue:shinny_mode forKey:@"shinny_mode"];
    [settings_data setValue:num_spheres forKey:@"num_spheres"];  
    
    // save context
    save_context();
}

//-----------------------------------------------------------------------------------------

NSManagedObject* fetch_settings()
{
    NSManagedObject *settings_data;
    
    AppDelegate *app_delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managed_context = [app_delegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Settings"];
    NSError *error = nil;
    
    NSArray *results = [managed_context executeFetchRequest:request error:&error];
    if(results.count == 0)
    {
        // set default settings on first save
        store_settings(@"49", @"dafult", @"not shinny");
        
    }
    else
    {
        settings_data = results[0];
    }
    
    save_context();
    return settings_data;
}

//-----------------------------------------------------------------------------------------

NSString* get_theme()
{
    NSManagedObject *settings_data = fetch_settings();
    return [settings_data valueForKey:@"theme"];
}

//-----------------------------------------------------------------------------------------

int get_num_spheres()
{
    NSManagedObject *settings_data = fetch_settings();
    NSString* num_spheres = [settings_data valueForKey:@"num_spheres"];
    return [num_spheres intValue];
}

//-----------------------------------------------------------------------------------------

NSString* get_shinny_mode()
{
    NSManagedObject *settings_data = fetch_settings();
    return [settings_data valueForKey:@"shinny_mode"];
}

//-----------------------------------------------------------------------------------------

