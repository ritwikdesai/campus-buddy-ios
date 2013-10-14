//
//  RDUtility.h
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 
 @class Util
 
 @abstract A utility class with some generally used functions.
 
 */

@interface RDUtility : NSObject

/*!
 @abstract get a Displayable Phone Number for a given Phone Number
 
 @discussion This is strictly for Campus Buddy database where last 4 digits of a phone numbers are stored for intercom
 
 @param number          Number retrieved form the Campus Buddy Database
 
 */

+(NSString*) getDisplayPhoneFromNumber:(NSString*) number;

/*!
 @abstract get a Dialable Phone Number for a given Phone Number
 
 @discussion This is strictly for Campus Buddy database where last 4 digits of a phone numbers are stored for intercom
 
 @param number          Number retrieved form the Campus Buddy Database
 
 */

+(NSString*) getDialablePhoneFromNumber:(NSString*) number;

/*!
 @abstract get a NSURL for a given Phone Number
 
 @discussion This should be a Dialable Phone Number
 
 @param number          Phone Number
 
 */


+(NSURL*) getPhoneURLForNumber:(NSString*)number;

/*!
 @abstract get Email Address for given username
 
 @discussion This should be a Dialable Phone Number
 
 @param username          Phone Number
 
 */

+(NSString*) getEmailAddressForUsername:(NSString*) username;

/*!
 @abstract get NSURL for Mail Address
 
 @param mailAddress        Mail Address constructed form getEmailAddressForUsername:(NSString*) username
 
 */

+(NSURL*) getEmailAddressURLForMailAddress:(NSString*) mailAddress;

//
// NSUserDefaults Operations

/*!
 @abstract save Object for a given Key
 
 @param object        Object to be saved
 
 @param key           Key for object
 
 */

+(BOOL) saveObject:(id) object forKey:(NSString*)key;

/*!
 @abstract save Object for a given Key in a NSDictionary of given Key
 
 @param object        Object to be saved
 
 @param key           Key for object
 
 @param dkey          Key for the NSDictionary
 
 */

+(BOOL) saveObject:(id) object forKey:(NSString *)key inDictionaryWithKey:(NSString*)dkey;

/*!
 @abstract Get Object for a given Key in a NSDictionary of given Key
 
 @param object        Object to retrive
 
 @param key           Key for object
 
 @param dkey          Key for the NSDictionary
 
 */

+(id) getObjectForKey:(NSString*)key fromDictionaryWithKey:(NSString*)dkey;

/*!
 @abstract Delete Object for a given Key in a NSDictionary of given Key
 
 @param object        Object to be removed
 
 @param key           Key for object
 
 @param dkey          Key for the NSDictionary
 
 */

+(BOOL) removeObjectForKey:(NSString*)key fromDictionaryWithKey:(NSString*)dkey;

/*!
 @abstract Delete Dictionary with key
 
 @param key          Key for the NSDictionary
 
 */

+(BOOL) removeDictionaryWithKey:(NSString*)key;

/*!
 @abstract Retrive Object for a given Key
 
  @param key           Key for object
 
 */

+(id) getObjectForKey:(NSString*)key;

/*!
 @abstract Delete Object for a given Key
 
 @param key           Key for object
 
 */

+(BOOL) removeObjectForKey:(NSString*)key;

/*!
 @abstract Clear all User Defaults
 
 */

+(void) clearDefaults;


/*!
 @abstract Returns center CGPoint
 
 */

+(CGPoint) centerPointOfScreen;

/*!
 @abstract Returns integer value corresponding to current day
 
 @discussion MONDAY = 0 , TUESDAY = 1 , WEDNESDAY = 3, THURSDAY = 4 , FRIDAY = 5
 
 */

+(NSInteger) currentDay;

/*!
 
 @abstract Check whether iOS 7 or earlier versions
 
 */

+(BOOL) isIOS7orLater;

/*!
 
 @abstract Execute a block of code on other Thread
 
 @discussion Data returned in form of dictionary is passed to the selector
 
 @param block               Block to execute
 
 @param target              Target instance to receive the message
 
 @param selector            Selector of target that receives data
 
 
*/

+(void) executeBlock:(NSDictionary*(^)())block target:(id)target selector:(SEL) selector;

@end
