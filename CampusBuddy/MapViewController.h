//
//  MapViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
@interface MapViewController : UIViewController<UIScrollViewDelegate,SWRevealViewControllerDelegate>
@property (weak, nonatomic)  UIScrollView *scrollView;

@end
