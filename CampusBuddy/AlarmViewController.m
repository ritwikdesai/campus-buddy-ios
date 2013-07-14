//
//  AlarmViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 13/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "AlarmViewController.h"
#import "SubjectListViewController.h"
#import "AlarmScheduler.h"
@interface AlarmViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)setAlarm:(id)sender;
@end

@implementation AlarmViewController
@synthesize period = _period;
@synthesize delegate = _delegate;
@synthesize subjectName = _subjectName;
@synthesize datePicker = _datePicker;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Details";
    
    self.subjectName.text = self.period.periodName;
    self.datePicker.timeZone = [NSTimeZone localTimeZone];
    self.datePicker.locale   = [NSLocale currentLocale];
    self.datePicker.calendar = [NSCalendar currentCalendar];
	// Do any additional setup after loading the view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showSubjects"])
    {
        [segue.destinationViewController setPeriod:self.period];
        [segue.destinationViewController setSegueTag:2];
        [segue.destinationViewController setDelegate:self];
    }
}

-(void)updateTimeTableEntryForTag:(NSInteger)tag withName:(NSString *)name
{
    self.subjectName.text = name;
    self.period.periodName = name;
    self.period.tag = tag;
    
    [self.delegate updateTimeTableEntryForTag:tag withName:name];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setAlarm:(id)sender {
   [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
   // UILocalNotification *_localNotification = [[UILocalNotification alloc]init];
//    
//    //setting the fire dat of the local notification
//    _localNotification.fireDate = self.datePicker.date;
//    
//    
//    //setting the time zone
//    _localNotification.timeZone = [NSTimeZone defaultTimeZone];
//    
//    //setting the message to display
//    _localNotification.alertBody = self.period.periodName;
//    
//    //default notification sound
//    _localNotification.soundName = UILocalNotificationDefaultSoundName;
//    
//    //displaying the badge number
//    _localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber]+1;
//     
//    //schedule a notification at its specified time with the help of the app delegate
//    [[UIApplication sharedApplication]scheduleLocalNotification:_localNotification];
    
//    NSDate *pickerDate = [self.datePicker date];
//    
//    // Schedule the notification
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = pickerDate;
//    localNotification.alertBody = self.period.periodName;
//    localNotification.alertAction = self.period.periodName;
//    localNotification.timeZone = [NSTimeZone defaultTimeZone];
//    localNotification.soundName = UILocalNotificationDefaultSoundName;
//    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//    
    [[AlarmScheduler Instance] scheduleNotificationOn:self.datePicker.date text:self.period.periodName action:@"View" sound:nil launchImage:nil andInfo:nil];
}
@end
