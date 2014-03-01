//
//  RDDatabaseHelper.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 15/10/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "RDDatabaseHelper.h"
#import "RDDataAccess.h"
#import "ContactCategory.h"
#import "ContactSubCategory.h"
#import "RDUtility.h"
#import "CKCalendarEvent.h"


@implementation RDDatabaseHelper

+(NSArray *)getContactCategoryList
{
    NSArray * returnArray = nil;
    
    RDDataAccess * oDataAccess = [RDDataAccess getDataAccessForDatabaseWithName:@"campusbuddy"];
    
    [oDataAccess openDatabase];
    
    returnArray = [oDataAccess getObjectModelOfClass:[ContactCategory class] fromTableWithName:@"contacts_category" forId:nil havingColumnName:@"_id" selectColumns:nil orderBy:ASC withRespectToColumns:[NSArray arrayWithObject:@"_category"] andHasColumnKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"categoryName",@"_category",@"categoryId",@"_id", nil]];
    
    [oDataAccess closeDatabase];
    
    return returnArray;
}

+(NSArray *)getContactSubCategoryListForId:(NSNumber *)ID
{
    NSArray * returnArray = nil;
    
    RDDataAccess * oDataAccess = [RDDataAccess getDataAccessForDatabaseWithName:@"campusbuddy"];
    
    [oDataAccess openDatabase];
    
    returnArray = [oDataAccess getObjectModelOfClass:[ContactSubCategory class] fromTableWithName:@"contacts_sub_category" forId:ID havingColumnName:@"_category_id" selectColumns:[NSArray arrayWithObjects:@"_id,_sub_category", nil] orderBy:ASC withRespectToColumns:[NSArray arrayWithObject:@"_sub_category"] andHasColumnKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"subCategoryName",@"_sub_category",@"subCategoryId",@"_id", nil]];
    
    [oDataAccess closeDatabase];
    
    return returnArray;
}

+(NSArray *) getContactDetailListForContactSubCategoryForId:(NSNumber *)ID
{
  RDDataAccess * oDataAccess = [RDDataAccess getDataAccessForDatabaseWithName:@"campusbuddy"];
    [oDataAccess openDatabase];
    
    FMResultSet * result =  [oDataAccess executeQuery:[NSString stringWithFormat:@"SELECT _id_details ,_more,_tel,_mail,_address FROM contact_details WHERE _sub_category_id = '%i'",[ID integerValue]]];
    
    NSMutableArray* array;
    NSMutableArray* namesArray;
    NSMutableArray* detailArray;
    
    array = [[NSMutableArray alloc] init];
    namesArray = [[NSMutableArray alloc] init];
    detailArray = [[NSMutableArray alloc] init];
    
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
            [detailArray addObject:[RDUtility getEmailAddressForUsername:mail]];
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

    [oDataAccess closeDatabase];
    
    
    return [array copy];
}

+(NSArray *)getEventsForDate:(NSDate *)date
{
    NSMutableArray * array;
    
    array = [[NSMutableArray alloc] init];
    NSDateFormatter  * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * from = [NSString stringWithString:[formater stringFromDate:date]];
    
    RDDataAccess * oDataAccess = [RDDataAccess getDataAccessForDatabaseWithName:@"calendardatabase"];
    [oDataAccess openDatabase];
    
    FMResultSet * result = [oDataAccess executeQuery:[NSString stringWithFormat:@"SELECT _description FROM calendar_events WHERE _date = '%@'",from]];
    
    while (result.next) {
        
        //NSString * date = (NSString*)[result objectForColumnName:@"_date"];
        NSString* description = [result objectForColumnName:@"_description"];
        
//        CKCalendarEvent * event = [CKCalendarEvent eventWithTitle:description andDate:[formater dateFromString:date] andInfo:nil];
        
        [array addObject:description];
    }

    
    [oDataAccess closeDatabase];
    
    return array;
}

+(NSDictionary *)getEventsDictionaryForYearNumber:(NSInteger)year MonthNumber:(NSInteger)mon
{
    NSMutableDictionary * dictionary;
    
    dictionary = [[NSMutableDictionary alloc] init];
    //NSDateFormatter  * formater = [[NSDateFormatter alloc] init];
    
    //[formater setDateFormat:@"yyyy-MM-dd"];
   
    NSString * from = mon<9 ? [NSString stringWithFormat:@"%d-0%d-01",year,mon] : [NSString stringWithFormat:@"%d-%d-01",year-1,mon+4] ;
    
    NSString * to = mon<9 ? [NSString stringWithFormat:@"%d-0%d-31",year,mon] : [NSString stringWithFormat:@"%d-%d-31",year-1,mon+4];
    
    RDDataAccess * oDataAccess = [RDDataAccess getDataAccessForDatabaseWithName:@"calendardatabase"];
    [oDataAccess openDatabase];
    
    FMResultSet * result = [oDataAccess executeQuery:[NSString stringWithFormat:@"SELECT distinct _date FROM calendar_events WHERE _date BETWEEN '%@' AND '%@' ",from,to]];
    
    while (result.next) {
        
        NSString * date = (NSString*)[result objectForColumnName:@"_date"];
        
        NSString * day = [date substringFromIndex:[date length] -2];
       
       [dictionary setValue:[NSNumber numberWithBool:YES] forKey:day];
        
//        CKCalendarEvent * event = [CKCalendarEvent eventWithTitle:description andDate:[formater dateFromString:date] andInfo:nil];
//        [array addObject:event];
    }
    
    
    [oDataAccess closeDatabase];
    
    return [dictionary copy];

}

+(NSArray *)getMapPlacesList
{
    NSArray * returnArray = nil;
    
   RDDataAccess * oDataAccess = [RDDataAccess getDataAccessForDatabaseWithName:@"campusbuddy"];
    
    [oDataAccess openDatabase];
    
    returnArray = [oDataAccess getObjectModelOfClass:[MapPlace class] fromTableWithName:@"table_info" forId:nil havingColumnName:@"_id_info" selectColumns:[NSArray arrayWithObjects:@"_id_info",@"_place", nil] orderBy:ASC withRespectToColumns:[NSArray arrayWithObject:@"_place"] andHasColumnKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"placeId",@"_id_info",@"placeName",@"_place", nil]];
    
    [oDataAccess closeDatabase];
    
    return returnArray;

}

+(MapPlace *)getPlaceFromPoint:(CGPoint)point
{
    NSArray * returnArray = nil;
    
    RDDataAccess * oDataAccess = [RDDataAccess getDataAccessForDatabaseWithName:@"campusbuddy"];
    
    [oDataAccess openDatabase];
    
    returnArray = [oDataAccess getObjectModelOfClass:[MapPlace class] fromTableWithName:@"table_venue" selectColumns:@[@"_touch_venue",@"_id_info"] whereClause:[NSString stringWithFormat:@"WHERE _minX < %f AND _minY < %f AND _maxX > %f AND _maxY> %f",point.x,point.y,point.x,point.y] orderBy:ASC withRespectToColumns:nil andHasColumnKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"placeName",@"_touch_venue",@"placeId",@"_id_info", nil]];
    
    [oDataAccess closeDatabase];
    
    return [returnArray objectAtIndex:0];
}

+(MapPlaceDetail *)getMapPlaceDetailsForId:(NSNumber *)ID
{
    NSArray * returnArray = nil;
    
    RDDataAccess * oDataAccess = [RDDataAccess getDataAccessForDatabaseWithName:@"campusbuddy"];
    
    [oDataAccess openDatabase];
    
    returnArray = [oDataAccess getObjectModelOfClass:[MapPlaceDetail class] fromTableWithName:@"table_info" forId:ID havingColumnName:@"_id_info" selectColumns:@[@"_info",@"_tel",@"_mail",@"_images"] orderBy:ASC withRespectToColumns:nil andHasColumnKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"placeDescription",@"_info",@"telephone",@"_tel",@"image",@"_images",@"mail",@"_mail", nil]];
    
    [oDataAccess closeDatabase];
    
    return [returnArray objectAtIndex:0];
}

+(NSArray *)getImageNamesForPlaceWithId:(NSNumber *)ID
{
    NSMutableArray * array;
    
    array = [[NSMutableArray alloc] init];
    RDDataAccess * oDataAccess = [RDDataAccess getDataAccessForDatabaseWithName:@"campusbuddy"];
    [oDataAccess openDatabase];
    
    FMResultSet * result = [oDataAccess executeQuery:[NSString stringWithFormat:@"SELECT _images FROM table_images WHERE _id_info = '%i'",[ID integerValue]]];
    
    while (result.next) {
        
        NSString* imageName =(NSString*) [result objectForColumnName:@"_images"];
        [array addObject:imageName];
    }
    
    [oDataAccess closeDatabase];
    return [array copy];
}

@end
