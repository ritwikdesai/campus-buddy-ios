//
//  ContactSubCategory.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "ContactSubCategory.h"

@implementation ContactSubCategory

@synthesize subCategoryId = _subCategoryId;

@synthesize subCategoryName = _subCategoryName;

-(NSString *)description
{
    NSString * descriptionString = nil;
    
    descriptionString = [NSString stringWithFormat:@"Sub Category Name : %@",self.subCategoryName];
    
    return descriptionString;
}

-(id)initWithSubCategoryName:(NSString *)name andId:(NSNumber *)Id
{
    self = [super init];
    
    if(self)
    {
        _subCategoryId = [Id copy];
        
        _subCategoryName = [name copy];
    }
    
    return self;
}

@end
