//
//  DatabaseHelper.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "DatabaseHelper.h"
#import "SDSAppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "ContactCategory.h"
#import "ContactDetails.h"
#import "ContactSubCategory.h"
@interface DatabaseHelper ()  


@end
@implementation DatabaseHelper

static DatabaseHelper* _databaseHelper;
static FMDatabase* _database;

+(DatabaseHelper*) getDatabaseHelper
{
    @synchronized([DatabaseHelper class])
    {
        if (!_databaseHelper)
          
        { _databaseHelper = [[self alloc] init];
         
          _database = [[FMDatabase alloc] initWithPath:[DatabaseHelper getDatabasePathFromAppDelegate]];
        }
        
        return _databaseHelper;
    }
    
    return nil;
}

-(NSArray*) getContactCategoryList
{
    NSMutableArray* array;
    
    array = [[NSMutableArray alloc] init];
    
    FMResultSet * result = [_database executeQuery:@"SELECT * FROM contacts_category;"];
    
    while (result.next) {
        
        ContactCategory * contact = [[ContactCategory alloc] init];
        contact.categoryId = [result objectForColumnName:@"_id"];
        contact.categoryName = (NSString*)[result objectForColumnName:@"_category"];
        
        [array addObject:contact];
    }
    
    return [array copy];

}

-(NSArray *)getContactSubCategoryListForId:(NSNumber *)ID
{
    NSMutableArray* array;
    
    array = [[NSMutableArray alloc] init];
    
    FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT _id , _sub_category FROM contacts_sub_category WHERE _category_id = '%i'",[ID integerValue]]];
    
    while (result.next) {
        
        ContactSubCategory * contact = [[ContactSubCategory alloc] init];
        contact.subCategoryId = [result objectForColumnName:@"_id"];
        contact.subCategoryName = (NSString*)[result objectForColumnName:@"_sub_category"];
        
        [array addObject:contact];
    }
    
    return [array copy];

    
}

-(NSArray*) getContactDetailListForContactSubCategoryForId:(NSNumber*)ID
{
    
}

-(BOOL) openDatabase
{
    BOOL success = NO;
    
    success = [_database open];
    
    return success;
}

-(BOOL) closeDatabase
{
    BOOL success = NO;
    
    success = [_database close];
    
    return success;
}


+(NSString*) getDatabasePathFromAppDelegate
{
     NSString *databaseString = [(SDSAppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    
    return databaseString;
}


@end
