//
//  SDSAppDelegate.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "EAIntroView.h"
#import "EAIntroPage.h"
@interface RDCampusBuddyAppDelegate : UIResponder <UIApplicationDelegate,EAIntroDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSString* databaseName;

@property NSString* databasePath;

@property BOOL firstAppLaunch;

-(void) applyAttributesForOlderVersions;

+(NSArray *) viewControllerIdentifiers;

+(void) showSideMenuWithDelegate:(id) delegate;

-(void) showTutorialInView:(UIView *)view;

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index controller:(UIViewController*) controller segueAutomatically:(BOOL)automatically;
    
+(instancetype) appDelegateInstance;
@end
