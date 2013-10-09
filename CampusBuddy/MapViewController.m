//
//  MapViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import "DatabaseHelper.h"
#import "PlacesViewController.h"

#import "MapDetailViewController.h"
@interface MapViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer ;
-(void)scrollViewSingleTapped:(UITapGestureRecognizer*)recognizer;
-(void) placesDropdown:(id)sender;


@end

@implementation MapViewController

 
@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionRight) self.view.userInteractionEnabled = NO;
    else self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	
    self.title = @"IITR Map";
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    
   // self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Places" style:UIBarButtonItemStyleBordered target:self action:@selector(placesDropdown:)];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"menu.png"];
    
    self.scrollView.delegate = self;
    self.revealViewController.delegate =self;
    
    UIImage *image = [UIImage imageNamed:@"iitrmap.png"];
   self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=self.imageView.image.size};
    [self.scrollView addSubview:self.imageView];
      
    self.scrollView.contentSize = self.imageView.image.size;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 1;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:singleTapRecognizer];
    //self.scrollView.delegate = self;
	// Do any additional setup after loading the view.
 //   [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
     
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

-(void) scrollViewSingleTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint p = [recognizer locationInView:self.imageView];
  
    DatabaseHelper* helper = [DatabaseHelper getDatabaseHelper];
    
    [helper openDatabase];
    
    //MapPoint* point = [helper getMapPoint:p];
    MapPlace * place = [helper getPlaceFromPoint:p];
    [helper closeDatabase];
    
    if(place == nil) return;
    
    [self performSegueWithIdentifier:@"detail" sender:place];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
