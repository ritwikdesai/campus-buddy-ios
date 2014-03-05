//
//  CalendarViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 29/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "CalendarViewController.h"
//#import "SWRevealViewController.h"
//#import "CKCalendarView.h"
#import "Util.h"
#import "RDDataAccess.h"
#import "RDDatabaseHelper.h"
#import "RDDayCell.h"
#import "RDUtility.h"
#import "CalendarEventDetailsViewController.h"
#import "RDCampusBuddyAppDelegate.h"
@interface CalendarViewController ()


//@property CKCalendarView * calendarView;

@property (strong, nonatomic) NSDictionary * events;

@end

@implementation CalendarViewController

#define CALENDAR_VIEW_CONTROLLER_TAG @"calendar"
//@synthesize calendarView = _calendarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
//{
//    if(position == FrontViewPositionRight) self.view.userInteractionEnabled = NO;
//    else self.view.userInteractionEnabled = YES;
//}


-(void) revealSideMenu
{
    
    [RDCampusBuddyAppDelegate showSideMenuWithDelegate:self];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    
    [sidebar dismissAnimated:YES completion:nil];
    
    if([[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index] isEqualToString:CALENDAR_VIEW_CONTROLLER_TAG])return;
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UIViewController * uvc = [board instantiateViewControllerWithIdentifier:[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index]];
    
    UINavigationController * s = self.navigationController;
    
    
    
    [self.navigationController setViewControllers:[[NSArray alloc] initWithObjects:uvc, nil] animated:NO];
    
    
    // [self.navigationController pushViewController:uvc animated:YES];
    
    NSLog(@"COUNT %d",[[s viewControllers] count]);
}


-(void) didPopulateData:(id) data
{
    self.events = (NSDictionary *)data;
    
    [self.calendarView updateUI];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Calendar";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table.png"]];
    
   if(!([[[UIDevice currentDevice] systemVersion]floatValue]<7.0)) [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
   self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealSideMenu)];
     self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"menu.png" ];
    
    __weak CalendarViewController * weakSelf = self;
    
    [RDUtility executeBlock:^NSDictionary *{
        
        NSDictionary * dic = [RDDatabaseHelper getEventsDictionaryForYearNumber:weakSelf.calendarView.month.year MonthNumber:weakSelf.calendarView.month.month];
        
        return dic;
        
    } target:weakSelf selector:@selector(didPopulateData:)];
    
    [[self.navigationController navigationBar] setTranslucent:NO];
    
    [[self calendarView] registerDayCellClass:[RDDayCell class]];
    
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", nil)
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:[self calendarView]
                                                                   action:@selector(showCurrentMonth)];
    [self.navigationItem setRightBarButtonItem:todayButton];

    
    
}



- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index {
    
    
    RDDayCell *exampleDayCell = (RDDayCell *)dayCell;
    
    NSString * dayString =nil;
    
    if(index<9) dayString = [NSString stringWithFormat:@"0%d",(index +1)];
    else dayString = [NSString stringWithFormat:@"%d",(index+1)];
    
    if([self.events objectForKey:dayString])[[exampleDayCell notificationView] setHidden:NO];
    
  
    
}

-(void)calendarView:(RDVCalendarView *)calendarView didChangeMonth:(NSDateComponents *)month
{
    //Avoiding Memory Cycles
    __weak CalendarViewController * weakSelf = self;
    
    [RDUtility executeBlock:^NSDictionary *{
        
        NSDictionary * dic = [RDDatabaseHelper getEventsDictionaryForYearNumber:weakSelf.calendarView.month.year MonthNumber:weakSelf.calendarView.month.month];
        
        return dic;
        
    } target:weakSelf selector:@selector(didPopulateData:)];
}

-(void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    NSDateFormatter  * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
   NSString * dat = [NSString stringWithString:[formater stringFromDate:date]];
   
    NSString* day = [dat substringFromIndex:[dat length] -2];
    
//    NSLog(@"Date : %@",from );
    
  if([self.events objectForKey:day])[self performSegueWithIdentifier:@"Event Details" sender:date];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Event Details"])
    {
        if([segue.destinationViewController isKindOfClass:[CalendarEventDetailsViewController class]])
        {
            CalendarEventDetailsViewController * cedvc = segue.destinationViewController;
            
            if([sender isKindOfClass:[NSDate class]])[cedvc setDate:sender];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
//{
//    NSArray * events = nil;
//    @try {
//
    // events = [RDDatabaseHelper getEventsForDate:date];
//        
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//    }
//    
//    return events;
//}
//
//-(void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event Description"
//                                                    message:event.title
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//}
//
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [self.calendarView setIsDataSourceReleased:YES];
//}
//
@end
