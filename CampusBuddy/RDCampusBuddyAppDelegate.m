//
//  SDSAppDelegate.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "RDCampusBuddyAppDelegate.h"
#import "MapViewController.h"
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
            
            _identifiers = [[NSArray alloc] initWithObjects:CONTACTS_VIEW_CONTROLLER_TAG,MAP_VIEW_CONTROLLER_TAG,CALENDAR_VIEW_CONTROLLER_TAG,TIME_TABLE_VIEW_CONTROLLER_TAG,ABOUT_US_VIEW_CONTROLLER_TAG,INSTRUCTIONS_TAG, nil];
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
    callout.width = 100;
    callout.itemSize = CGSizeMake(70, 70);

    callout.tintColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    callout.itemBackgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [callout show];
}


-(void)showTutorialInView:(UIView *)view
{
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Instructions";
    page1.desc = @"Tapping menu button reveals options.";
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_instruction"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Telephone Directory";
   page2.desc = @"Displays Telephone Directory of IIT Roorkee.";
    page2.bgImage = [UIImage imageNamed:@"bg1"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tel"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"IIT Roorkee Map";
//    page3.desc = @"Displays IIT Roorkee Map with important places listed. Tapping on a location displays its details.";
    page3.bgImage = [UIImage imageNamed:@"bg1"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maps-pin"]];
    
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"Academic Calendar";
//    page4.desc = @"Displays the Academic Calendar of IIT Roorkee.";
    page4.bgImage = [UIImage imageNamed:@"bg1"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar"]];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"Time Table";
//    page5.desc = @"Set your daily college time table.Also set reminders for classes.";
    page5.bgImage = [UIImage imageNamed:@"bg1"];
    page5.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"university"]];
    
    
    EAIntroView * introView = [[EAIntroView alloc] initWithFrame:view.bounds andPages:@[page1,page2,page3,page4,page5]];
    
    [introView showInView:view animateDuration:0.3];
    
    [introView setDelegate:self];
}


-(void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSInteger)pageIndex
{
    //Last Page
    if(pageIndex != [introView.pages count]-1) [introView.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    
    else [introView.skipButton setTitle:@"Done" forState:UIControlStateNormal];
}


+(instancetype)appDelegateInstance
{
    RDCampusBuddyAppDelegate * instance = (RDCampusBuddyAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return instance;
    
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
   
   // if(![RDUtility isIOS7orLater]) [self applyAttributesForOlderVersions];
    
    if([RDUtility getObjectForKey:LAUNCH_FLAG]) {
        
        self.firstAppLaunch = NO;
        
    }
    
    else{
        
        self.firstAppLaunch = YES;
        
        [RDUtility saveObject:[NSNumber numberWithBool:YES] forKey:LAUNCH_FLAG];
    }
     
    return YES;
}


-(void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index controller:(UIViewController *)controller segueAutomatically:(BOOL)automatically
{
    [sidebar dismissAnimated:YES completion:nil];
    
    if(!automatically) return;
    
    NSLog(@"Preparing for Segue");
    
    if([[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index] isEqualToString:@"info"]){
        
        [[RDCampusBuddyAppDelegate appDelegateInstance] showTutorialInView:controller.navigationController.view];
    }
    
    else{
        UIStoryboard * board = [UIStoryboard storyboardWithName:STORYBOARD_IPHONE bundle:nil];
        
        UIViewController * uvc = [board instantiateViewControllerWithIdentifier:[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index]];
        
        
        [controller.navigationController setViewControllers:[[NSArray alloc] initWithObjects:uvc, nil] animated:NO];
    }

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
