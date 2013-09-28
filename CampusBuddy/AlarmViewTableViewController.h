//
//  AlarmViewTableViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 28/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTableDelegate.h"
#import "Period.h"
@interface AlarmViewTableViewController : UITableViewController<TimeTableDelegate>
@property id<TimeTableDelegate> delegate;
@property Period* period;
@end
