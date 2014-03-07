//
//  MapViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "MapViewController.h"
//#import "SWRevealViewController.h"
#import "RDDataAccess.h"
#import "PlacesViewController.h"
#import "RDDatabaseHelper.h"
#import "RDUtility.h"
#import "MapDetailViewController.h"
#import "RDCampusBuddyAppDelegate.h"
@interface MapViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer ;

-(void)scrollViewSingleTapped:(UITapGestureRecognizer*)recognizer;

-(void) placesDropdown:(id)sender;

-(void) didPopulateData:(id)data;

-(void) initializeViews;

-(void) initializeGestures;

@end

@implementation MapViewController


 
@synthesize scrollView = _scrollView;

//
//-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
//{
//    if(position == FrontViewPositionRight) self.view.userInteractionEnabled = NO;
//    else self.view.userInteractionEnabled = YES;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self initializeViews];
    
    [self initializeGestures];
    
}

-(void)initializeViews
{
    self.title = @"IITR Map";
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealSideMenu)];
    
    // self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Places" style:UIBarButtonItemStyleBordered target:self action:@selector(placesDropdown:)];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"menu.png"];
    
    self.scrollView.delegate = self;
    //self.revealViewController.delegate =self;
    
    UIImage *image = [UIImage imageNamed:@"iitrmap.png"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=self.imageView.image.size};
    [self.scrollView addSubview:self.imageView];
    
    self.scrollView.contentSize = self.imageView.image.size;

}
-(void) revealSideMenu
{
    
    [RDCampusBuddyAppDelegate showSideMenuWithDelegate:self];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    
    
    
    [[RDCampusBuddyAppDelegate appDelegateInstance] sidebar:sidebar didTapItemAtIndex:index controller:self segueAutomatically:![[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index] isEqualToString:MAP_VIEW_CONTROLLER_TAG]];
    

}

-(void)initializeGestures
{
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 1;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:singleTapRecognizer];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
    
}

-(void) placesDropdown:(id)sender
{
    [self performSegueWithIdentifier:@"placeList" sender:self];
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    // 2
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

  
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detail"])
    {
        
        [segue.destinationViewController setPlaceFromPoint:(MapPlace *)sender];
    }
    
     
}

-(void)didPopulateData:(id)data
{
    MapPlace * place = [data objectForKey:@"place"];
    
    if(place != nil) [self performSegueWithIdentifier:@"detail" sender:place];
}

-(void) scrollViewSingleTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint p = [recognizer locationInView:self.imageView];
  
    [RDUtility executeBlock:^NSDictionary *{
        
        MapPlace * place = [RDDatabaseHelper getPlaceFromPoint:p];
        
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:place,@"place", nil];
       
        return dic;
        
    } target:self selector:@selector(didPopulateData:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
