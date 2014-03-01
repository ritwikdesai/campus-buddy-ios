//
//  MapDetailViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "MapDetailViewController.h"
#import "RDDataAccess.h"
#import "MapPlaceDetail.h"
#import "RDDatabaseHelper.h"
#import "RDUtility.h"
@interface MapDetailViewController ()
-(void) configureViewForPlace;
-(void) configureViewForPoint;
-(void) configureViewForPortrait;
-(void) configureViewForLandscape;

@property MapPlaceDetail* detail;
@property NSArray* imageNamesArray;
@property double SCREEN_HEIGHT;
-(void) setupScrollViewForImageArray:(NSArray*)imagesArray ;
-(void) configureTextView;
@end

@implementation MapDetailViewController

@synthesize detail = _detail;
@synthesize place = _place;
@synthesize textView = _textView;
@synthesize imageNamesArray = _imageNamesArray;
@synthesize placeFromPoint = _placeFromPoint;
@synthesize mainScrollView = _mainScrollView;
@synthesize scroll = _scroll;
@synthesize SCREEN_HEIGHT = _SCREEN_HEIGHT;

#define IMAGE_SCROLL_WIDTH  280
#define IMAGE_SCROLL_HEIGHT 200
#define TEXTVIEW_DUMMY_HEIGHT 100
#define ORIGIN_X 20
#define ORIGIN_Y_SCROLL 20
#define ORIGIN_Y_TEXTVIEW 228
#define TEXTVIEW_WIDTH_POTRAIT 280

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
    //Get Screen Height
    self.SCREEN_HEIGHT = [UIScreen mainScreen].bounds.size.height;
    if(!([[[UIDevice currentDevice] systemVersion]floatValue]<7.0)) [self setEdgesForExtendedLayout:UIRectEdgeNone];
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait){
        
        [self configureViewForPortrait];
    }
    
    else
    {
        [self configureViewForLandscape];
    }
    if(self.place) [self configureViewForPlace];
    else [self configureViewForPoint];
//
     
}



-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

    if(self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
         [self configureViewForPortrait];
    }
    
    else
    {
        [self configureViewForLandscape];
    }
}

-(void)configureViewForPortrait
{
    if(self.scroll == nil) {
        
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y_SCROLL, IMAGE_SCROLL_WIDTH, IMAGE_SCROLL_HEIGHT)];
        
        [self.mainScrollView addSubview:self.scroll];
    
    }
    else
    {
        [self.scroll setFrame:CGRectMake(ORIGIN_X, ORIGIN_Y_SCROLL, IMAGE_SCROLL_WIDTH, IMAGE_SCROLL_HEIGHT)];
        [self.scroll setNeedsDisplay];
    }
    if(self.textView == nil){
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y_TEXTVIEW,TEXTVIEW_WIDTH_POTRAIT,TEXTVIEW_DUMMY_HEIGHT)];
        [self configureTextView];
        [self.mainScrollView addSubview:self.textView];

        
    }
    else
    {
        [self.textView setFrame:CGRectMake(ORIGIN_X, ORIGIN_Y_TEXTVIEW,TEXTVIEW_WIDTH_POTRAIT,TEXTVIEW_DUMMY_HEIGHT)];
        [self.textView setNeedsDisplay];
        [self.textView setFrame:CGRectMake(ORIGIN_X,ORIGIN_Y_TEXTVIEW,TEXTVIEW_WIDTH_POTRAIT,self.textView.contentSize.height)];
        [self.textView sizeToFit];
        [self.textView setNeedsDisplay];
        [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width,228+ self.textView.frame.size.height)];
    }
  
    
  
}

-(void) configureViewForLandscape
{
    
    if(self.scroll == nil) {
        
        double xPosition = [RDUtility centerPointOfScreen].y-IMAGE_SCROLL_WIDTH/2;
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(xPosition, ORIGIN_Y_SCROLL, IMAGE_SCROLL_WIDTH, IMAGE_SCROLL_HEIGHT)];
        [self configureTextView];
        [self.mainScrollView addSubview:self.scroll];
        
    }
   else{
       double xPosition = [RDUtility centerPointOfScreen].y-IMAGE_SCROLL_WIDTH/2;
       
       [self.scroll setFrame:CGRectMake(xPosition, ORIGIN_Y_SCROLL, IMAGE_SCROLL_WIDTH, IMAGE_SCROLL_HEIGHT)];
       [self.scroll setNeedsDisplay];
   }
    
    if(self.textView == nil){
        
        double width = self.SCREEN_HEIGHT - 2*ORIGIN_X;
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y_TEXTVIEW,width,TEXTVIEW_DUMMY_HEIGHT)];
        [self configureTextView];
    [self.mainScrollView addSubview:self.textView];
    }
    else
    {
        double width = self.SCREEN_HEIGHT - 2*ORIGIN_X;
        [self.textView setFrame:CGRectMake(ORIGIN_X, ORIGIN_Y_TEXTVIEW,width,TEXTVIEW_DUMMY_HEIGHT)];
        [self.textView setNeedsDisplay];
        [self.textView setFrame:CGRectMake(ORIGIN_X,ORIGIN_Y_TEXTVIEW,width,self.textView.contentSize.height)];
        [self.textView sizeToFit];
        [self.textView setNeedsDisplay];
        [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width,ORIGIN_Y_TEXTVIEW+ self.textView.frame.size.height)];
    }
    

    
}



-(void)configureTextView

{   [self.textView setScrollEnabled:NO];
    [self.textView setEditable:NO];
    [self.textView setTextAlignment:NSTextAlignmentJustified];
    [self.textView setDataDetectorTypes:UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber];
    [self.textView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    
}
-(void)configureViewForPlace
{
    self.title = self.place.placeName;
 
    self.detail = [RDDatabaseHelper getMapPlaceDetailsForId:self.place.placeId];
    self.imageNamesArray = [RDDatabaseHelper getImageNamesForPlaceWithId:self.place.placeId];
    

    
 
    [self setupScrollViewForImageArray:self.imageNamesArray];

   self.textView.text = self.detail.placeDescription;
    
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        
        [self.textView setFrame:CGRectMake(ORIGIN_X, ORIGIN_Y_TEXTVIEW,TEXTVIEW_WIDTH_POTRAIT,self.textView.contentSize.height)];
        [self.textView sizeToFit];
        [self.textView setNeedsDisplay];
         [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width,ORIGIN_Y_TEXTVIEW+ self.textView.frame.size.height)];
    }
    
    else
    {
         double width = self.SCREEN_HEIGHT - 2*ORIGIN_X;
        [self.textView setFrame:CGRectMake(ORIGIN_X, ORIGIN_Y_TEXTVIEW,width,self.textView.contentSize.height)];
        [self.textView sizeToFit];
        [self.textView setNeedsDisplay];
        
[self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width,ORIGIN_Y_TEXTVIEW+ self.textView.frame.size.height)];
    }
    
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
        [v setFrame:CGRectMake(0, 0, IMAGE_SCROLL_WIDTH, IMAGE_SCROLL_HEIGHT)];
        [self.scroll addSubview:v];
        
        self.scroll.contentSize = CGSizeMake(IMAGE_SCROLL_WIDTH,self.scroll.frame.size.height);
        return;
    }
    for (int i=0; i<numberOfViews; i++) {
        NSString* imageName = [imagesArray objectAtIndex:i];
        UIImageView * v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];

        [v setFrame:CGRectMake(0+IMAGE_SCROLL_WIDTH*i, 0, IMAGE_SCROLL_WIDTH, IMAGE_SCROLL_HEIGHT)];
        [self.scroll addSubview:v];
    }
    


    //set the scroll view content size
    self.scroll.contentSize = CGSizeMake(IMAGE_SCROLL_WIDTH*numberOfViews,IMAGE_SCROLL_HEIGHT);
                                            
     
}



-(void)configureViewForPoint
{
    self.title = self.placeFromPoint.placeName;
    self.detail = [RDDatabaseHelper getMapPlaceDetailsForId:self.placeFromPoint.placeId];
    self.imageNamesArray = [RDDatabaseHelper getImageNamesForPlaceWithId:self.placeFromPoint.placeId];
    
    
    
    
    [self setupScrollViewForImageArray:self.imageNamesArray];
    
    self.textView.text = self.detail.placeDescription;
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        
        [self.textView setFrame:CGRectMake(ORIGIN_X, ORIGIN_Y_TEXTVIEW,TEXTVIEW_WIDTH_POTRAIT,self.textView.contentSize.height)];
        [self.textView sizeToFit];
        [self.textView setNeedsDisplay];
        [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width,ORIGIN_Y_TEXTVIEW+ self.textView.frame.size.height)];
    }
    
    else
    {
        double width = self.SCREEN_HEIGHT - 2*ORIGIN_X;
        [self.textView setFrame:CGRectMake(ORIGIN_X, ORIGIN_Y_TEXTVIEW,width,self.textView.contentSize.height)];
        [self.textView sizeToFit];
        [self.textView setNeedsDisplay];
        
        [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width,ORIGIN_Y_TEXTVIEW+ self.textView.frame.size.height)];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
