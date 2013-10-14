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
#import "Util.h"
#import "RDDataAccess.h"
@interface CalendarViewController ()


@property CKCalendarView * calendarView;


@end

@implementation CalendarViewController

@synthesize calendarView = _calendarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionRight) self.view.userInteractionEnabled = NO;
    else self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Calendar";
    
   if(!([[[UIDevice currentDevice] systemVersion]floatValue]<7.0)) [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"menu.png"];
    
    self.calendarView = [CKCalendarView new];
    self.revealViewController.delegate = self;
   [self.calendarView setDelegate:self];
   [self.calendarView setDataSource:self];
  [[self view] addSubview:self.calendarView];
    
    NSLog(@"SELF %@",self);
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    NSArray * events = nil;
    @try {
        RDDataAccess * databaseHelper = [RDDataAccess getDatabaseHelperForDatabaseWithName:@"calendardatabase"];
        [databaseHelper openDatabase];
        
        events = [databaseHelper getEventsForDate:date];
        
        [databaseHelper closeDatabase];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
    
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

-(void)viewDidDisappear:(BOOL)animated
{
    [self.calendarView setIsDataSourceReleased:YES];
}
@end
