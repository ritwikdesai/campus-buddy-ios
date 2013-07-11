//
//  CalenderViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 11/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalViewController.h"
@interface CalenderViewController : UINavigationController<UITableViewDelegate>
@property id dataSource;
@end
