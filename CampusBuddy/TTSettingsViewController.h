//
//  TTSettingsViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 15/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTableDataSource.h"
#import "IITRTimeTableParser.h"
@interface TTSettingsViewController : UITableViewController<IITRTimeTableDelegate>
@property id <TimeTableDataSource> dataSource;
@end
