//
//  SDSAppDelegate.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "RDCampusBuddyAppDelegate.h"
#import "MapViewController.h"
//#import "SWRevealViewController.h"
#import "MapDetailViewController.h"
#import "RDUtility.h"
#import "RDAlarmScheduler.h"
@implementation RDCampusBuddyAppDelegate

@synthesize databaseName = _databaseName;
@synthesize databasePath = _databasePath;

static NSArray * _identifiers;

+(NSArray *)viewControllerIdentifiers
{
    @synchronized(self)
    {
        if(_identifiers)
        {
            return _identifiers;
        }
        
        else {
            
            _identifiers = [[NSArray alloc] initWithObjects:@"tel",@"map",@"calendar",@"timetable",@"aboutus",@"info", nil];
            return _identifiers;
        }
    }
}

+(void)showSideMenuWithDelegate:(id)delegate
{
    NSArray *images = @[
                        [UIImage imageNamed:@"tel.png"],
                        [UIImage imageNamed:@"maps-pin.png"],
                        [UIImage imageNamed:@"calendar.png"],
                        [UIImage imageNamed:@"university.png"],
                        [UIImage imageNamed:@"aboutus.png"],
                        [UIImage imageNamed:@"help.png"]
                        
                        
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:104/255.f green:80/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:178/255.f green:239/255.f blue:240/255.f alpha:1],
                        
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:nil borderColors:colors];
    
    //   RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = delegate;
    callout.width = 125;
    callout.itemSize = CGSizeMake(80, 80);

    callout.tintColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    callout.itemBackgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [callout show];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	
    if (localNotification)
	{
		[[RDAlarmScheduler Instance] handleReceivedNotification:localNotification];
    }
    
    else {
        [[RDAlarmScheduler Instance] clearBadgeCount];
    }
   
    if(![RDUtility isIOS7orLater]) [self applyAttributesForOlderVersions];
     
    return YES;
}

-(void)applyAttributesForOlderVersions
{
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]] ;
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor blackColor], UITextAttributeTextColor,
//                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
//                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
//                                                           UITextAttributeTextShadowOffset,
//                                                           [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], UITextAttributeFont, nil]];
//    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor colorWithRed:51.0/255.0 green:162.0/255.0 blue:252.0/255.0 alpha:1]];
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
    [[RDAlarmScheduler Instance] handleReceivedNotification:notification forUIApplicationState:[application applicationState] forSender:self];
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
