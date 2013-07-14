//
//  MapDetailViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPlace.h"
#import "MapPoint.h"
@interface MapDetailViewController : UIViewController
@property MapPlace* place;
@property MapPlace* placeFromPoint;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak,nonatomic) IBOutlet UIScrollView * mainScrollView;
@end
