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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

 
-(void) revealSideMenu
{
    
    [RDCampusBuddyAppDelegate showSideMenuWithDelegate:self];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    
    [[RDCampusBuddyAppDelegate appDelegateInstance] sidebar:sidebar didTapItemAtIndex:index controller:self segueAutomatically:![[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index] isEqualToString:CALENDAR_VIEW_CONTROLLER_TAG]];
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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2"]];
    
   if(!([[[UIDevice currentDevice] systemVersion]floatValue]<7.0)) [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealSideMenu)];
    
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
    
    if(index<9) dayString = [NSString stringWithFormat:@"0%ld",(index +1)];
    else dayString = [NSString stringWithFormat:@"%ld",(index+1)];
    
    if([self.events objectForKey:dayString])[[exampleDayCell notificationView] setHidden:NO];
    
    else [[exampleDayCell notificationView] setHidden:YES];
    
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
    
  if([self.events objectForKey:day])
      [self performSegueWithIdentifier:@"Event Details" sender:date];
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

@end
