//
//  RDAlarmScheduler.h
//
//  Created by Ritwik Desai on 14/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDAlarmScheduler : NSObject

/*!
 
 @abstract  Returns Instance of RDAlarmScheduler Class
 
 */
+ (RDAlarmScheduler*) Instance;


/*!
 
 @abstract  Setup Local Notification
 
 @param fireDate           Date upon which Notification is fired
 
 @param alertText          Alert Text of the Notification

 @param alertAction        Alert Action of the Notification
 
 @param soundfileName      Name of sound file for Notification (can be nil)
 
 @param launchImage        Lockscreen Notification Image
 
 @param userInfo           UserInfo (can be nil)
 
 */
- (void) scheduleNotificationOn:(NSDate*) fireDate
						   text:(NSString*) alertText
						 action:(NSString*) alertAction
						  sound:(NSString*) soundfileName
					launchImage:(NSString*) launchImage
						andInfo:(NSDictionary*) userInfo;


/*!
 
 @abstract  Handle received Notification

 */

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification;


/*!
 
 @abstract  Decrease App Badge Icon Count by given value
 
 @param count   Decrease Factor
 
 */

- (void) decreaseBadgeCountBy:(int) count;

/*!
 
 @abstract  Clear Badge Count
 
 */

- (void) clearBadgeCount;

/*!
 
 @abstract  Handle received Notification for Application State
 
 */

-(void) handleReceivedNotification:(UILocalNotification *)thisNotification forUIApplicationState:(UIApplicationState) state forSender:sender;

@property int badgeCount;

@end
