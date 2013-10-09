//
//  ContactSubCategory.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactSubCategory : NSObject

@property (readonly)  NSString* subCategoryName;

@property  (readonly) NSNumber* subCategoryId;

-(id)initWithSubCategoryName:(NSString*)name andId:(NSNumber*) Id;

@end
