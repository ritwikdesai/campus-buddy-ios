//
//  Util.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+(NSString*) getDisplayPhoneFromNumber:(NSString*) number;
+(NSString*) getDialablePhoneFromNumber:(NSString*) number;
+(NSURL*) getPhoneURLForNumber:(NSString*)number;
+(NSString*) getEmailAddress:(NSString*) mail;
+(NSURL*) getEmailAddressURL:(NSString*) mail;
+(BOOL) saveObject:(id) object forKey:(NSString*)key;
+(BOOL) saveObject:(id) object forKey:(NSString *)key inDictionaryWithKey:(NSString*)dkey;
+(id) getObjectForKey:(NSString*)key fromDictionaryWithKey:(NSString*)dkey;
+(BOOL) removeObjectForKey:(NSString*)key fromDictionaryWithKey:(NSString*)dkey;
+(BOOL) removeDictionaryWithKey:(NSString*)key;
+(id) getObjectForKey:(NSString*)key;
+(BOOL) removeObjectForKey:(NSString*)key;
+(void) clearDefaults;
+(CGPoint) centerPointOfScreen;
@end
