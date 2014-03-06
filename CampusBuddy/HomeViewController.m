//
//  HomeViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "HomeViewController.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"
#import "RNFrostedSidebar.h"
#import "RDCampusBuddyAppDelegate.h"
@interface HomeViewController ()

//@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

-(void)showTutorial;

@end

@implementation HomeViewController

#define HOME_VIEW_CONTROLLER_TAG @"home"

@synthesize sidebarButton = _sidebarButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}


-(void)showTutorial
{
    
    [[RDCampusBuddyAppDelegate appDelegateInstance] showTutorialInView:self.navigationController.view];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _sidebarButton.target = self;
    _sidebarButton.action = @selector(revealSideMenu);
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor purpleColor], NSForegroundColorAttributeName, nil];
    
    if([[RDCampusBuddyAppDelegate appDelegateInstance] firstAppLaunch])[self showTutorial];
}

-(void) revealSideMenu
{
  
    [RDCampusBuddyAppDelegate showSideMenuWithDelegate:self];

}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    [[RDCampusBuddyAppDelegate appDelegateInstance] sidebar:sidebar didTapItemAtIndex:index controller:self segueAutomatically:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
