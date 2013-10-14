//
//  AlarmCell.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 28/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "AlarmCell.h"
#import "RDAlarmScheduler.h"
@implementation AlarmCell

@synthesize datePicker = _datePicker;
@synthesize period = _period;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)setAlarm:(id)sender {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[RDAlarmScheduler Instance] scheduleNotificationOn:self.datePicker.date text:self.period.periodName action:@"View" sound:nil launchImage:nil andInfo:nil];
    NSLog(@"Alarm Set %@",@"");
}
@end
