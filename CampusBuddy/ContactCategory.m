//
//  ContactCategory.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 09/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "ContactCategory.h"

@implementation ContactCategory

@synthesize categoryName = _categoryName;

@synthesize categoryId = _categoryId;

-(NSString *)description
{
    NSString * descriptionString = nil;
    
    descriptionString = [NSString stringWithFormat:@"Contact Category Name : %@",self.categoryName];
    return  descriptionString;
}

-(id)initWithCategoryName:(NSString *)name andCategoryId:(NSNumber *)Id
{
    self = [super init];
    
    if(self)
    {
        _categoryId = [Id copy];
        
        _categoryName = [name copy];
    }
    
    return self;
}

@end
