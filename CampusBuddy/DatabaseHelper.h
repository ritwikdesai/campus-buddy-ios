//
//  DatabaseHelper.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "MapPlace.h"
#import "MapPlaceDetail.h"
@interface DatabaseHelper : NSObject


+(NSString *) getDatabasePathFromAppDelegate ;
+(DatabaseHelper*) getDatabaseHelper;
+(DatabaseHelper*) getDatabaseHelperForDatabaseWithName:(NSString *) name;
-(BOOL) openDatabase;
-(BOOL) closeDatabase;

//Specific to Campus Buddy
-(NSArray*) getContactCategoryList;
-(NSArray*) getContactSubCategoryListForId:(NSNumber*)ID;
-(NSArray*) getContactDetailListForContactSubCategoryForId:(NSNumber*)ID;
-(NSArray*) getEventsForDate:(NSDate*)date;
-(NSDictionary*) getEvents;
-(NSArray*) getMapPlacesList;
-(MapPlace *)getPlaceFromPoint:(CGPoint)point;
-(MapPlaceDetail*)getMapPlaceDetailsForId:(NSNumber*)ID;
-(NSArray*) getImageNamesForPlaceWithId:(NSNumber*)ID;

//Generalized
-(id) getObjectModelOfClass:(Class) model fromTableWithName:(NSString*) tableName  forId:(NSNumber*)ID withIdColumnName:(NSString*)columnName;

@end
