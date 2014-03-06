//
//  HomeViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "EAIntroView.h"
@interface HomeViewController : UIViewController<RNFrostedSidebarDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
