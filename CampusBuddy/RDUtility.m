//
//  RDUtility.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "RDUtility.h"

@implementation RDUtility

+(NSString *)getDialablePhoneFromNumber:(NSString *)number
{
    NSMutableString* finalNumber = [[NSMutableString alloc] initWithCapacity:10];
    int num = number.length;
    
    if(num ==4){
        
        [finalNumber appendString:@"0133228"];
        [finalNumber appendString:number];
    }
    
    if(num ==6){
        
        [finalNumber appendString:@"01332"];
        [finalNumber appendString:number];
    }
    return [finalNumber copy];
}

+(NSString *)getDisplayPhoneFromNumber:(NSString *)number
{
    
    NSMutableString* finalNumber = [[NSMutableString alloc] initWithCapacity:10];
    int num = number.length;
    
    if(num ==4){
        
        [finalNumber appendString:@"0133-228"];
        [finalNumber appendString:number];
    }
    
    if(num ==6){
        
        [finalNumber appendString:@"0133-2"];
        [finalNumber appendString:number];
    }
    
    if(num == 10) [finalNumber appendString:number];
    return [finalNumber copy];
    
}

+(NSString*)getEmailAddressForUsername:(NSString *)username
{
    NSString* atString = @"@";
    if ([username rangeOfString:atString].location==NSNotFound)
    {
        NSMutableString* str = [NSMutableString stringWithString:username];
        [str appendString:@"@iitr.ernet.in"];
        return [str copy];
    }
    else
    {
        return username;
    }
}

+(NSURL*) getPhoneURLForNumber:(NSString *)number
{
    NSString * dialableNumber = [RDUtility getDialablePhoneFromNumber:number];

    NSMutableString * s = [NSMutableString stringWithString:@"telprompt://"];
    [s appendString:dialableNumber];
   
    NSURL * url = [NSURL URLWithString:s];
    return url;
}

+(NSURL*) getEmailAddressURLForMailAddress:(NSString *)mailAddress
{

    NSString * add = [RDUtility getEmailAddressForUsername:mailAddress];
    NSMutableString * s = [NSMutableString stringWithString:@"mailto://"];
    [s appendString:add];
    
    NSURL * url = [NSURL URLWithString:s];
    return url;
}

+(BOOL)saveObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ([object isKindOfClass:[NSObject class]]) {
        [defaults setObject:object forKey:key];
        
        return [defaults synchronize];
    }
    
    return NO;
}

+(id) getObjectForKey:(NSString *)key
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    id returnVal = [defaults objectForKey:key];
    return returnVal;
}

+(BOOL) removeObjectForKey:(NSString *)key
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
     [defaults removeObjectForKey:key];
    return YES;
}

+(BOOL)saveObject:(id)object forKey:(NSString *)key inDictionaryWithKey:(NSString *)dkey
{
       NSDictionary * d = [RDUtility getObjectForKey:dkey];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:d];
    
    [dictionary setValue:object forKey:key];
    [RDUtility saveObject:[dictionary copy] forKey:dkey];
    return YES;
}

+(id)getObjectForKey:(NSString *)key fromDictionaryWithKey:(NSString *)dkey
{
    NSDictionary * dictionary = [RDUtility getObjectForKey:dkey];
    
    id returnVal = [dictionary valueForKey:key];
    
    return returnVal;
}

+(BOOL)removeObjectForKey:(NSString *)key fromDictionaryWithKey:(NSString *)dkey
{
    NSDictionary * dictionary = [RDUtility getObjectForKey:dkey];
    [dictionary setNilValueForKey:key];
    [RDUtility saveObject:dictionary forKey:dkey];
    return YES;
}

+(BOOL)removeDictionaryWithKey:(NSString *)key
{
    [RDUtility removeObjectForKey:key];
    return YES;
}

+ (void)clearDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
}

+(CGPoint)centerPointOfScreen
{
    CGPoint point; 
    point.x = [UIScreen mainScreen].bounds.size.width/2;
    point.y = [UIScreen mainScreen].bounds.size.height/2;
    return point;
}

+(NSInteger)currentDay
{
    NSDate * date = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
    
    int weekDay = [dateComponents weekday];
    
    if(weekDay<2 || weekDay>6) return 0;
    
    else return weekDay-2;
    
}

+(BOOL)isIOS7orLater
{
    if( [[[UIDevice currentDevice] systemVersion] floatValue]  <7.0) return NO;
    else return YES;
}

+(void)executeBlock:(NSDictionary *(^)())block target:(id)target selector:(SEL)selector
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
      
        
         NSDictionary * data = block();
        
        
        if([target respondsToSelector:selector])
        {
            
            
            [target performSelectorOnMainThread:selector withObject:data waitUntilDone:YES];
            
        }
        
        
    });

}

@end
