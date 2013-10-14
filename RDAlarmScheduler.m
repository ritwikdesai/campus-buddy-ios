//
//  AlarmScheduler.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 14/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "RDAlarmScheduler.h"

static RDAlarmScheduler* _instance;

@implementation RDAlarmScheduler

@synthesize badgeCount = _badgeCount;
+ (RDAlarmScheduler*)Instance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
			 
				_instance = [[super allocWithZone:NULL] init];
				_instance.badgeCount = 0;

        }
    }
    return _instance;
}

- (void) scheduleNotificationOn:(NSDate*) fireDate
                           text:(NSString*) alertText
                         action:(NSString*) alertAction
                          sound:(NSString*) soundfileName
                    launchImage:(NSString*) launchImage
                        andInfo:(NSDictionary*) userInfo


{
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
	
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;
	
	if(soundfileName == nil)
	{
		localNotification.soundName = UILocalNotificationDefaultSoundName;
	}
	else
	{
		localNotification.soundName = soundfileName;
	}
    
	if(launchImage)localNotification.alertLaunchImage = launchImage;
	
	self.badgeCount ++;
    localNotification.applicationIconBadgeNumber = self.badgeCount;
    localNotification.userInfo = userInfo;
	
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

- (void) clearBadgeCount
{
	self.badgeCount = 0;
	[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void) decreaseBadgeCountBy:(int) count
{
	self.badgeCount -= count;
	if(self.badgeCount < 0) self.badgeCount = 0;
	
	[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification
{
	NSLog(@"Received: %@",[thisNotification description]);
	[self decreaseBadgeCountBy:1];
}

-(void) handleReceivedNotification:(UILocalNotification *)thisNotification forUIApplicationState:(UIApplicationState)state forSender:sender
{
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:thisNotification.alertBody
                                                       delegate:sender cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
[self handleReceivedNotification:thisNotification];
}


@end
