//
//  CalendarViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 29/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "CalendarViewController.h"
#import "SWRevealViewController.h"
#import "CKCalendarView.h"
#import "DatabaseHelper.h"
@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Calendar";
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    CKCalendarView * calenderView = [CKCalendarView new];

    [calenderView setDelegate:self];
    [calenderView setDataSource:self];
    [[self view] addSubview:calenderView];
    
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    DatabaseHelper * databaseHelper = [DatabaseHelper getDatabaseHelperForDatabaseWithName:@"calendardatabase"];
  [databaseHelper openDatabase];
   
  NSArray* events = [databaseHelper getEventsForDate:date];
   
    [databaseHelper closeDatabase];
    
    return events;
}

-(void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event Description"
                                                    message:event.title
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
