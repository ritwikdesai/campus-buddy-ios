//
//  ContactDetails.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 09/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "ContactDetails.h"

@implementation ContactDetails

@synthesize contactTitle = _contactTitle;

@synthesize address = _address;

@synthesize detailId = _detailId;

@synthesize phoneNumber = _phoneNumber;

@synthesize mail = _mail;

-(NSString *)description
{
    NSString * descriptionString = nil;
    
    descriptionString = [NSString stringWithFormat:@"Contact Name : %@ \nAddress : %@ \nPhone Number : %@ \nEmail : %@ ",self.contactTitle,self.address,self.phoneNumber,self.mail];
    
    return descriptionString;
}

-(id)initWithContactTitle:(NSString *)title Id:(NSNumber *)Id phoneNumber:(NSString *)number address:(NSString *)address andMail:(NSString *)mail
{
    self = [super init];
    
    if(self)
    {
        _contactTitle = [title copy];
        
        _detailId = [Id copy];
        
        _phoneNumber = [number copy];
        
        _address = [address copy];
        
        _mail = [mail copy];
    }
    
    return self;
}

@end
