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
#import "CKCalendarEvent.h"
#import "MapPlace.h"
#import "MapPlaceDetail.h"
#import "Util.h"
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

-(id)getObjectModelOfClass:(id)model fromTableWithName:(NSString *)tableName forId:(NSNumber *)ID withIdColumnName:(NSString *)columnName
{
    id oObject = [[model alloc] init];
    NSMutableArray * columnNames = [[NSMutableArray alloc] init];
    NSMutableString * string = [[NSMutableString alloc] initWithString:@"PRAGMA table_info("];
    [string appendString:tableName];
    [string appendString:@");"];
    FMResultSet* result = [_database executeQuery:string];
    while (result.next) {
        [columnNames addObject:(NSString*)[result objectForColumnName:@"name"]];
    }
    
    FMResultSet * resultfortable = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%i'",tableName,columnName,[ID integerValue]]];
    
    BOOL get = resultfortable.next;
    if (get) {
        NSLog(@"Database Contains data: %@",@"YES");
    }
    
    @try {
        for (int i=0; i<columnNames.count; i++) {
           
            
            [oObject setValue:[resultfortable objectForColumnName:[columnNames objectAtIndex:i]] forKey:[columnNames objectAtIndex:i]];
        
        }

    }
    @catch (NSException *exception) {
        NSLog(@"Error Model Database Mismatch Error : %@",exception.name);
    }
    @finally {
        // Done
    }

    return oObject;
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
    NSMutableArray* namesArray;
    NSMutableArray* detailArray;
     
    array = [[NSMutableArray alloc] init];
    namesArray = [[NSMutableArray alloc] init];
    detailArray = [[NSMutableArray alloc] init];
    
    FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT _id_details ,_more,_tel,_mail,_address FROM contact_details WHERE _sub_category_id = '%i'",[ID integerValue]]];
    
    while (result.next) {
       
       // [array addObject:[result objectForColumnName:@"_id_details"]];
        
        NSString * contactTitle = (NSString*)[result objectForColumnName:@"_more"];
        if( contactTitle.length !=0)
        {
            [namesArray addObject:@"Name"];
            [detailArray addObject:contactTitle];
        }
        NSString * phoneNumber = (NSString*)[result objectForColumnName:@"_tel"];
        
        if(phoneNumber.length !=0 )
        {
            [namesArray addObject:@"Phone Number"];
            [detailArray addObject:phoneNumber];
        }
        NSString * mail = (NSString*)[result objectForColumnName:@"_mail"];
        
        if(mail.length !=0)
        {
            [namesArray addObject:@"E-Mail"];
            [detailArray addObject:[Util getEmailAddress:mail]];
        }
        NSString * address = (NSString*)[result objectForColumnName:@"_address"];
        
        if(address.length !=0)
            
        {
            [namesArray addObject:@"Address"];
            [detailArray addObject:address];
        }
        
        [array addObject:[namesArray copy]];
        [array addObject:[detailArray copy]];

    }
    
    return [array copy];
}


-(NSArray*)getEventsForDate:(NSDate*)date
{
    NSMutableArray * array;
    
    array = [[NSMutableArray alloc] init];
    NSDateFormatter  * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * from = [NSString stringWithString:[formater stringFromDate:date]];
    
   
//  FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM calendar_events WHERE _date BETWEEN '%@'AND '%@'",from,to]];
    FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM calendar_events WHERE _date = '%@'",from]];
    
    while (result.next) {
        
        NSString * date = (NSString*)[result objectForColumnName:@"_date"];
        NSString* description = [result objectForColumnName:@"_description"];
//        Event  * event = [[Event alloc] init];
//        event.date = [formater dateFromString:date];
//        event.eventDescription = description;
        CKCalendarEvent * event = [CKCalendarEvent eventWithTitle:description andDate:[formater dateFromString:date] andInfo:nil];
        [array addObject:event];
    }

    return [array copy];
}

-(NSDictionary *)getEvents
{
    NSMutableDictionary * array;
    
    array = [[NSMutableDictionary alloc] init];
    NSDateFormatter  * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];

    
    
    //  FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM calendar_events WHERE _date BETWEEN '%@'AND '%@'",from,to]];
    FMResultSet * result = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM calendar_events "]];
    
    while (result.next) {
        
        NSString * date = (NSString*)[result objectForColumnName:@"_date"];
        NSString* description = [result objectForColumnName:@"_description"];
        //        Event  * event = [[Event alloc] init];
        //        event.date = [formater dateFromString:date];
        //        event.eventDescription = description;
        CKCalendarEvent * event = [CKCalendarEvent eventWithTitle:description andDate:[formater dateFromString:date] andInfo:nil];
        [array setObject:event forKey:[formater dateFromString:date]];
    }
    
    return [array copy];
}

-(MapPlace *)getPlaceFromPoint:(CGPoint)point
{
    FMResultSet* result = [_database executeQuery:[NSString stringWithFormat:@"SELECT _touch_venue,_id_info FROM table_venue WHERE _minX < %f AND _minY < %f AND _maxX > %f AND _maxY> %f",point.x,point.y,point.x,point.y]];
    NSMutableArray* pointArray = [[NSMutableArray alloc] initWithCapacity:1];
    while (result.next) {
        
        NSString * d = (NSString*)[result objectForColumnName:@"_touch_venue"];
        MapPlace * place = [[MapPlace alloc] init];
        place.placeName = d;
        place.placeId = [result objectForColumnName:@"_id_info"];
        [pointArray addObject:place];
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
    mapplacedetail.image = (NSString*) [result objectForColumnName:@"_images"];
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
