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
@implementation SDSAppDelegate

@synthesize databaseName = _databaseName;
@synthesize databasePath = _databasePath;
  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.databaseName = @"campusbuddy.db";

//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDir = [documentPaths objectAtIndex:0];
//    self.databasePath = [documentDir stringByAppendingPathComponent:self.databaseName];
//    self.calendarDatabasePath = [documentDir stringByAppendingPathComponent:self.calendarDatabaseName];
//    [self createAndCheckDatabaseWithPath:self.databasePath andName:self.databaseName];
    // Override point for customization after application launch.
   
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]] ;
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:51.0/255.0 green:162.0/255.0 blue:252.0/255.0 alpha:1], UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                           UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], UITextAttributeFont, nil]];
     
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1], UITextAttributeTextColor,nil]
//                                                                                            forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor colorWithRed:51.0/255.0 green:162.0/255.0 blue:252.0/255.0 alpha:1]];
     
    // Override point for customization after application launch.
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{NSUInteger orientations =UIInterfaceOrientationMaskAllButUpsideDown;
    if(self.window.rootViewController){
        
        UIViewController * currentViewController = (UIViewController*)[[(UINavigationController*)[(SWRevealViewController*)self.window.rootViewController frontViewController] viewControllers ] lastObject];
        NSLog(@"Current View Controller : %@",[currentViewController class]);
        
          if([currentViewController isKindOfClass:[KalViewController class]] || [currentViewController isKindOfClass:[MapDetailViewController class]])  orientations = UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
        
          else orientations = UIInterfaceOrientationMaskAll;
    }
    return orientations;
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
