//
//  ContactCategory.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 09/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactCategory : NSObject

@property (readonly)  NSString* categoryName;

@property (readonly)  NSNumber * categoryId;

-(id)initWithCategoryName:(NSString*) name andCategoryId:(NSNumber*) Id;

@end
