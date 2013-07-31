//
//  TimeTableViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 13/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTableDelegate.h"
#import "TimeTableDataSource.h"
@interface TimeTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TimeTableDelegate,TimeTableDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic)  UITableView *tableView;

@end