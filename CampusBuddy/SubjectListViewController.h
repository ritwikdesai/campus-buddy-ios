//
//  SubjectListViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 13/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Period.h"
#import "TimeTableDelegate.h"
@interface SubjectListViewController : UITableViewController<TimeTableDelegate>

@property NSInteger segueTag;
@property Period* period;
@property id<TimeTableDelegate> delegate;
@end
