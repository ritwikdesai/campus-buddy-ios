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
#import "MapPlace.h"
#import "MapPlaceDetail.h"
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

-(MapPoint *)getMapPoint:(CGPoint)point
{
    FMResultSet* result = [_database executeQuery:[NSString stringWithFormat:@"SELECT _touch_venue FROM table_venue WHERE _minX < %f AND _minY < %f AND _maxX > %f AND _maxY> %f",point.x,point.y,point.x,point.y]];
    NSMutableArray* pointArray = [[NSMutableArray alloc] initWithCapacity:1];
    while (result.next) {
        
        NSString * d = (NSString*)[result objectForColumnName:@"_touch_venue"];
        MapPoint * mapPoint = [[MapPoint alloc] initWithPoint:point andDescription:d];
        [pointArray addObject:mapPoint];
    }
    
    if (pointArray.count ==0) {
        return nil;
    }
    return [pointArray objectAtIndex:0];
}

-(NSArray*) getMapPlacesList
{
    NSMutableArray * array;
    
    array = [[NSMutableArray alloc] init];
     
    
    FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT _id_info,_place FROM table_info"]];
    
    while (result.next) {
        
        NSNumber * placeId = (NSNumber*)[result objectForColumnName:@"_id_info"];
        NSString* placeName = [result objectForColumnName:@"_place"];
        MapPlace  * place = [[MapPlace alloc] init];
        place.placeName = placeName;
        place.placeId = placeId;
        [array addObject:place];
    }
    
    return [array copy];
}

-(MapPlaceDetail*) getMapPlaceDetailsForId:(NSNumber*)ID
{
    MapPlaceDetail * mapplacedetail = [[MapPlaceDetail alloc] init];
   FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT _info,_tel,_mail,_images FROM table_info WHERE _id_info = '%i'",[ID integerValue]]];
   
   BOOL get =  result.next;
    
    mapplacedetail.placeDescription = (NSString*) [result objectForColumnName:@"_info"];
    mapplacedetail.image = (NSString*) [result objectForColumnName:@"_image"];
    mapplacedetail.telephone = (NSString*) [result objectForColumnName:@"_tel"];
    mapplacedetail.mail = (NSString*) [result objectForColumnName:@"_mail"];
    
    return mapplacedetail;
}

-(NSArray*) getImageNamesForPlaceWithId:(NSNumber*)ID
{
    NSMutableArray * array;
    
    array = [[NSMutableArray alloc] init];
    
    
    FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT _images FROM table_images WHERE _id_info = '%i'",[ID integerValue]]];
    
    while (result.next) {
        
        NSString* imageName =(NSString*) [result objectForColumnName:@"_images"];
        [array addObject:imageName];
    }
    
    return [array copy];

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
