//
//  CalenderViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 11/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "CalenderViewController.h"
#import "KalViewController.h"
#import "SWRevealViewController.h"
#import "CalendarDataSource.h"

@interface CalenderViewController ()

@property KalViewController * kal;


@end

@implementation CalenderViewController

@synthesize kal = _kal;
@synthesize dataSource =_dataSource;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

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
    self.kal = [[KalViewController alloc] init];
    self.title = @"Calendar";
    self.kal.delegate = self;
    self.dataSource = [[CalendarDataSource alloc] init];
    self.kal.dataSource = self.dataSource;

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)];
    
    // Set the gesture
    [self.navigationController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.navigationController addChildViewController:self.kal];
	// Do any additional setup after loading the view.
}

- (void)showAndSelectToday
{
    [self.kal showAndSelectDate:[NSDate date]];
}

 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *myevent = [self.dataSource eventAtIndexPath :indexPath];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event Description"
                                                    message:myevent.eventDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
   }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
