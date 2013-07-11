//
//  CalendarDataSource.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 11/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kal.h"
#import "Event.h"
@interface CalendarDataSource : NSObject<KalDataSource>
{
    NSMutableArray *items;
    NSMutableArray *events;
}

+(CalendarDataSource *)dataSource;
-(Event*)eventAtIndexPath:(NSIndexPath*) indexPath;
@end
