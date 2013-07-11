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
#import "Event.h"
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

+(DatabaseHelper *)getDatabaseHelperForDatabaseWithName:(NSString *)name
{
    @synchronized([DatabaseHelper class])
    {
        if (!_databaseHelper)
            
        { _databaseHelper = [[self alloc] init];
            
            _database = [[FMDatabase alloc] initWithPath:[DatabaseHelper getDatabasePathWithName:name]];
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
    NSMutableArray* array;
     
    array = [[NSMutableArray alloc] init];
    
    FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT _id_details ,_more,_tel,_mail,_address FROM contact_details WHERE _sub_category_id = '%i'",[ID integerValue]]];
    
    while (result.next) {
        
        ContactDetails * contact = [[ContactDetails alloc] init];
        contact.detailId = [result objectForColumnName:@"_id_details"];
        contact.contactTitle = (NSString*)[result objectForColumnName:@"_more"];
        contact.phoneNumber = (NSString*)[result objectForColumnName:@"_tel"];
        contact.mail = (NSString*)[result objectForColumnName:@"_mail"];
        contact.address = (NSString*)[result objectForColumnName:@"_address"];
        
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
    _databaseHelper = nil;
    return success;
}

-(NSMutableArray*)getEventsForFromDate:(NSDate*)fromDate to:(NSDate*)toDate
{
    NSMutableArray * array;
    
    array = [[NSMutableArray alloc] init];
    NSDateFormatter  * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * from = [NSString stringWithString:[formater stringFromDate:fromDate]];
    NSString* to = [NSString stringWithString:[formater stringFromDate:toDate]];
    NSString* k = [NSString stringWithFormat:@"SELECT * FROM calendar_events WHERE _date BETWEEN '%@' AND '%@'",from,to];
  FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM calendar_events WHERE _date BETWEEN '%@'AND '%@'",from,to]];
    
    while (result.next) {
        
        NSString * date = (NSString*)[result objectForColumnName:@"_date"];
        NSString* description = [result objectForColumnName:@"_description"];
        Event  * event = [[Event alloc] init];
        event.date = [formater dateFromString:date];
        event.eventDescription = description;
        [array addObject:event];
    }

    return array;
}

+(NSString*) getDatabasePathFromAppDelegate
{
   //  NSString *databaseString = [(SDSAppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    NSString *databaseString = [[NSBundle mainBundle] pathForResource:@"campusbuddy" ofType:@"db"];
    return databaseString;
}

+(NSString*) getDatabasePathWithName:(NSString*)name
{
    //  NSString *databaseString = [(SDSAppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    NSString *databaseString = [[NSBundle mainBundle] pathForResource:name ofType:@"db"];
    return databaseString;
}

@end
