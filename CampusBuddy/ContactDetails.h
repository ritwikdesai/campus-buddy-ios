//
//  ContactDetails.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 09/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactDetails : NSObject

@property (readonly)  NSNumber * detailId;

@property (readonly) NSString * contactTitle;

@property (readonly) NSString * phoneNumber;

@property (readonly) NSString * address;

@property (readonly) NSString * mail;

-(id)initWithContactTitle:(NSString *) title Id:(NSNumber*) Id phoneNumber:(NSString*) number address:(NSString*) address andMail:(NSString*)mail;

@end
