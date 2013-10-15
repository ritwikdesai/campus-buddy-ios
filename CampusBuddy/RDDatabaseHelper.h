//
//  RDDatabaseHelper.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 15/10/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapPlace.h"
#import "MapPoint.h"
#import "MapPlaceDetail.h"
@interface RDDatabaseHelper : NSObject

+(NSArray*) getContactCategoryList;

+(NSArray*) getContactSubCategoryListForId:(NSNumber*)ID;

+(NSArray*) getContactDetailListForContactSubCategoryForId:(NSNumber*)ID;

+(NSArray*)getEventsForDate:(NSDate*)date;

+(NSArray*) getMapPlacesList;

+(MapPlace *)getPlaceFromPoint:(CGPoint)point;

+(MapPlaceDetail*)getMapPlaceDetailsForId:(NSNumber*)ID;

+(NSArray*) getImageNamesForPlaceWithId:(NSNumber*)ID;
@end
