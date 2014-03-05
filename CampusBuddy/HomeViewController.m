//
//  HomeViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "HomeViewController.h"
//#import "SWRevealViewController.h"
#import "RNFrostedSidebar.h"
#import "RDCampusBuddyAppDelegate.h"
@interface HomeViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Change button color
    //_sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
   
    //_sidebarButton.target = self.revealViewController;
    //_sidebarButton.action = @selector(revealToggle:);
    
    _sidebarButton.target = self;
    _sidebarButton.action = @selector(revealSideMenu);
    
    
    self.navigationController.navigationBar.translucent = NO;
    
    // Set the gesture
   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	// Do any additional setup after loading the view.
    
    //[self performSegueWithIdentifier:@"startApp" sender:nil];
}

-(void) revealSideMenu
{
  
    [RDCampusBuddyAppDelegate showSideMenuWithDelegate:self];

}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    
    [sidebar dismissAnimated:YES completion:nil];
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UIViewController * uvc = [board instantiateViewControllerWithIdentifier:[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index]];
    
    UINavigationController * s = self.navigationController;
    
    
   
    [self.navigationController setViewControllers:[[NSArray alloc] initWithObjects:uvc, nil] animated:NO];
   
    
   // [self.navigationController pushViewController:uvc animated:YES];
 
     NSLog(@"COUNT %d",[[s viewControllers] count]);
}

-(void)dealloc
{
    NSLog(@"Dealloc");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
