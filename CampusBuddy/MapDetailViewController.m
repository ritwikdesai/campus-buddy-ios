//
//  MapDetailViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "MapDetailViewController.h"
#import "DatabaseHelper.h"
#import "MapPlaceDetail.h"
@interface MapDetailViewController ()
-(void) configureViewForPlace;
-(void) configureViewForPoint;
@property MapPlaceDetail* detail;
@property NSArray* imageNamesArray;
-(void) setupScrollViewForImageArray:(NSArray*)imagesArray ;
@end

@implementation MapDetailViewController

@synthesize detail = _detail;
@synthesize place = _place;
@synthesize textView = _textView;
@synthesize imageNamesArray = _imageNamesArray;
@synthesize placeFromPoint = _placeFromPoint;
@synthesize mainScrollView = _mainScrollView;
@synthesize scroll = _scroll;
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
    
    if(self.place) [self configureViewForPlace];
    }

-(void)configureViewForPlace
{
    self.title = self.place.placeName;
    DatabaseHelper * helper = [DatabaseHelper getDatabaseHelper];
    [helper openDatabase];
    self.detail = [helper getMapPlaceDetailsForId:self.place.placeId];
    self.imageNamesArray = [helper getImageNamesForPlaceWithId:self.place.placeId];
    [helper closeDatabase];
    
 
    [self setupScrollViewForImageArray:self.imageNamesArray];
    self.textView.text = self.detail.placeDescription;
    
}

-(void) setupScrollViewForImageArray:(NSArray*)imagesArray {
    //add the scrollview to the view
    //[self.scroll setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.scroll.pagingEnabled = YES;
    [self.scroll setAlwaysBounceVertical:NO];
    //setup internal views
    NSInteger numberOfViews = imagesArray.count;
    if(numberOfViews == 0)
    {
        UIImageView * v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_image.png"]];

        //
        [v setFrame:CGRectMake(0, 0, 280, 200)];
        [self.scroll addSubview:v];
        
        self.scroll.contentSize = CGSizeMake(280,self.scroll.frame.size.height);
        return;
    }
    for (int i=0; i<numberOfViews; i++) {
        NSString* imageName = [imagesArray objectAtIndex:i];
        UIImageView * v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];

        [v setFrame:CGRectMake(0+280*i, 0, 280, 200)];
        [self.scroll addSubview:v];
    }
    
//    UIImageView * v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_image.png"]];
//    //
//       [v setFrame:CGRectMake(0, 0, 280, 200)];
//        [self.scroll addSubview:v];

    //set the scroll view content size
    self.scroll.contentSize = CGSizeMake(280*numberOfViews,200);
                                            
    //add the scrollview to this view
    //[self.view addSubview:self.scroll];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    
}

-(void)configureViewForPoint
{
    self.title = self.placeFromPoint.placeName;
    DatabaseHelper * helper = [DatabaseHelper getDatabaseHelper];
    [helper openDatabase];
    self.detail = [helper getMapPlaceDetailsForId:self.placeFromPoint.placeId];
    self.imageNamesArray = [helper getImageNamesForPlaceWithId:self.placeFromPoint.placeId];
    [helper closeDatabase];
    
    
    [self setupScrollViewForImageArray:self.imageNamesArray];
    self.textView.text = self.detail.placeDescription;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
