//
//  CalendarDataSource.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 11/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "CalendarDataSource.h"
#import "DatabaseHelper.h"
static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface CalendarDataSource()

- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end
@implementation CalendarDataSource


+(CalendarDataSource*)dataSource
{
    return [[[self class] alloc] init];
}

- (id)init
{
    if ((self = [super init])) {
        items = [[NSMutableArray alloc] init];
        events = [[NSMutableArray alloc] init];
    }
    return self;
}

-(Event *)eventAtIndexPath:(NSIndexPath *)indexPath
{
    return [items objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    cell.textLabel.numberOfLines = 3;
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    Event *myEvent = [self eventAtIndexPath:indexPath];
    cell.textLabel.text = myEvent.eventDescription;

    return cell;
}

 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (void)loadEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    //Load Stuff
    DatabaseHelper * databaseHelper = [DatabaseHelper getDatabaseHelperForDatabaseWithName:@"calendardatabase"];
    [databaseHelper openDatabase];
    
    events = [databaseHelper getEventsForFromDate:fromDate to:toDate];
    
    [databaseHelper closeDatabase];
    
    [delegate loadedDataSource:self];
}

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    [events removeAllObjects];
    [self loadEventsFrom:fromDate to:toDate delegate:delegate];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    return [[self eventsFrom:fromDate to:toDate] valueForKeyPath:@"date"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    [items addObjectsFromArray:[self eventsFrom:fromDate to:toDate]];
}

- (void)removeAllItems
{
    [items removeAllObjects];
}

- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSMutableArray *matches = [NSMutableArray array];
    for (Event *myEvent in events)
        if (IsDateBetweenInclusive(myEvent.date, fromDate, toDate))
            [matches addObject:myEvent];
    
    return matches;
}
@end
