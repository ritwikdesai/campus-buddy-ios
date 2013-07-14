//
//  AlarmViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 13/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTableDelegate.h"
#import "Period.h"
@interface AlarmViewController : UIViewController<TimeTableDelegate>
@property id<TimeTableDelegate> delegate;
@property  Period* period;
@property (weak, nonatomic) IBOutlet UILabel *subjectName;
@end
