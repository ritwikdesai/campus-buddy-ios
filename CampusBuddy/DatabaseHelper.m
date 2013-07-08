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

-(NSArray *)getContactListForId:(NSNumber *)ID
{
    NSMutableArray* array;
    
    array = [[NSMutableArray alloc] init];
    
    FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT _id_details , _advanced FROM contact_details WHERE _category_id = '%i'",[ID integerValue]]];
    
    while (result.next) {
        
        ContactDetails * contact = [[ContactDetails alloc] init];
        contact.detailId = [result objectForColumnName:@"_id_details"];
        contact.contactTitle = (NSString*)[result objectForColumnName:@"_advanced"];
        
        [array addObject:contact];
    }
    
    return [array copy];

    
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
