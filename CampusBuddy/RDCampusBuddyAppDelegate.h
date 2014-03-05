//
//  SDSAppDelegate.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
@interface RDCampusBuddyAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSString* databaseName;
@property NSString* databasePath;

-(void) applyAttributesForOlderVersions;

+(NSArray *) viewControllerIdentifiers;

+(void) showSideMenuWithDelegate:(id) delegate;

@end
