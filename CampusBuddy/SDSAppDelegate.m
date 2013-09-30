//
//  SDSAppDelegate.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "SDSAppDelegate.h"
#import "MapViewController.h"
#import "SWRevealViewController.h"
#import "KalViewController.h"
#import "MapDetailViewController.h"
#import "AlarmScheduler.h"
@implementation SDSAppDelegate

@synthesize databaseName = _databaseName;
@synthesize databasePath = _databasePath;
  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	
    if (localNotification)
	{
		[[AlarmScheduler Instance] handleReceivedNotification:localNotification];
    }
    
    else {
        [[AlarmScheduler Instance] clearBadgeCount];
    }
   
    // Override point for customization after application launch.
    return YES;
}


-(void) createAndCheckDatabaseWithPath:(NSString*)path andName:(NSString*) name
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:path];
    
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:path error:nil];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[AlarmScheduler Instance] handleReceivedNotification:notification forUIApplicationState:[application applicationState] forSender:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
