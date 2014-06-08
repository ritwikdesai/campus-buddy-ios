//
//  RDTimeTableViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 29/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "RDTimeTableViewController.h"
//#import "SWRevealViewController.h"
#import "RDUtility.h"
#import "AlarmViewTableViewController.h"

@interface RDTimeTableViewController ()

@property NSArray * timeArray;
@property NSArray * data;
@property NSInteger currentDay;

-(void) selectSettings:(id) sender;
@end

@implementation RDTimeTableViewController
@synthesize tableView = _tableView;
@synthesize timeArray = _timeArray;
@synthesize data = _data;
@synthesize currentDay = _currentDay;
@synthesize dayPicker = _dayPicker;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentDay = [RDUtility currentDay];
   
    [self.dayPicker setSelectedSegmentIndex:self.currentDay];
    
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealSideMenu)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(selectSettings:)];
   

    
     

    self.title = @"Time Table";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.timeArray =@[@"8 am - 9 am",@"9am - 10am",@"10 am - 11 am",@"11 am - 12 pm",@"12 pm - 1 pm",@"2pm - 3pm",@"3 pm - 4 pm",@"4 pm - 5 pm",@"5 pm - 6 pm"];
	 
    
    //Exp
    
        
}


-(void) revealSideMenu
{
    
    [RDCampusBuddyAppDelegate showSideMenuWithDelegate:self];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    
    [[RDCampusBuddyAppDelegate appDelegateInstance] sidebar:sidebar didTapItemAtIndex:index controller:self segueAutomatically:![[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index] isEqualToString:TIME_TABLE_VIEW_CONTROLLER_TAG] ];
}


//-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
//{
//    if(position == FrontViewPositionRight) self.view.userInteractionEnabled = NO;
//    else self.view.userInteractionEnabled = YES;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.timeArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.timeArray objectAtIndex:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

  if(([[[UIDevice currentDevice] systemVersion]floatValue]<7.0)) cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    NSInteger i = 100 *(indexPath.section +1) + self.currentDay;
    
    NSLog(@"DEX %li",(long)i);
    
    NSString * subjectName = [RDUtility getObjectForKey:[NSString stringWithFormat:@"%li",(long)i] fromDictionaryWithKey:@"TT"];
    
    if(subjectName != nil) cell.textLabel.text = [NSString stringWithString:subjectName];
    
    else cell.textLabel.text = @"Off";
    
    return cell;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    if([segue.identifier isEqualToString:@"alarm"])
    {
        if([sender isKindOfClass:[Period class]]){
            
        Period * period = (Period*)sender;
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setPeriod:period];
        }
        
    }

    if ([segue.identifier isEqualToString:@"showSettings"]) {
        [segue.destinationViewController setDataSource:self];
    }
}

- (IBAction)datePicked:(id)sender {
    
    UISegmentedControl * control = (UISegmentedControl*) sender;
    
    self.currentDay = control.selectedSegmentIndex;
    
    [self.tableView reloadData];
    
    
}

-(void)reloadTimeTable
{
    [self.tableView reloadData];
}
-(void)selectSettings:(id)sender
{
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

 
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];

    Period * period = [[Period alloc] init];
    period.tag = 100 *(indexPath.section +1) + self.currentDay;
    period.periodName = cell.textLabel.text;
    
    [self performSegueWithIdentifier:@"alarm" sender:period];
}

-(void)updateTimeTableEntryForTag:(NSInteger)tag withName:(NSString *)name
{
    [self reloadTimeTable];
}
@end
