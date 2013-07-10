//
//  Util.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "Util.h"

@implementation Util

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
    return [finalNumber copy];
    
}

+(NSString*)getEmailAddress:(NSString *)mail
{
    NSString* atString = @"@";
    if ([mail rangeOfString:atString].location==NSNotFound)
    {
        NSMutableString* str = [NSMutableString stringWithString:mail];
        [str appendString:@"@iitr.ernet.in"];
        return [str copy];
    }
    else
    {
        return mail;
    }
}
+(NSURL*) getPhoneURLForNumber:(NSString *)number
{
    NSString * dialableNumber = [Util getDialablePhoneFromNumber:number];

    NSMutableString * s = [NSMutableString stringWithString:@"telprompt://"];
    [s appendString:dialableNumber];
   
    NSURL * url = [NSURL URLWithString:s];
    return url;
}

+(NSURL*) getEmailAddressURL:(NSString*) mail
{

    NSString * add = [Util getEmailAddress:mail];
    NSMutableString * s = [NSMutableString stringWithString:@"mailto://"];
    [s appendString:add];
    
    NSURL * url = [NSURL URLWithString:s];
    return url;
}
@end
