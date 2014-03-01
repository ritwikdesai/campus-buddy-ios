//
//  CalendarEventDetailsViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 01/03/14.
//  Copyright (c) 2014 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarEventDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSDate* date;

@end
