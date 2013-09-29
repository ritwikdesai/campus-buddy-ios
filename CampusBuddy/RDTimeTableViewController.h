//
//  RDTimeTableViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 29/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTableDelegate.h"
#import "TimeTableDataSource.h"
@interface RDTimeTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TimeTableDelegate,TimeTableDataSource>
 
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)datePicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dayPicker;

@end
