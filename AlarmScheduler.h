//
//  AlarmScheduler.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 14/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmScheduler : NSObject

+ (AlarmScheduler*) Instance;

- (void) scheduleNotificationOn:(NSDate*) fireDate
						   text:(NSString*) alertText
						 action:(NSString*) alertAction
						  sound:(NSString*) soundfileName
					launchImage:(NSString*) launchImage
						andInfo:(NSDictionary*) userInfo;

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification;

- (void) decreaseBadgeCountBy:(int) count;
- (void) clearBadgeCount;
-(void) handleReceivedNotification:(UILocalNotification *)thisNotification forUIApplicationState:(UIApplicationState) state forSender:sender;
@property int badgeCount;

@end
