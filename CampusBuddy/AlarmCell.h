//
//  AlarmCell.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 28/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Period.h"
@interface AlarmCell : UITableViewCell
- (IBAction)setAlarm:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property Period * period;
@end
