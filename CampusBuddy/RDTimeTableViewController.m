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

#define TIME_TABLE_VIEW_CONTROLLER_TAG @"timetable"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentDay = [RDUtility currentDay];
   
    [self.dayPicker setSelectedSegmentIndex:self.currentDay];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealSideMenu)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(selectSettings:)];
   
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"menu.png"];
    
    //self.revealViewController.delegate = self;

    self.title = @"Time Table";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.timeArray =@[@"8-9",@"9-10",@"10-11",@"11-12",@"12-1",@"2-3",@"3-4",@"4-5",@"5-6"];
	// Do any additional setup after loading the view.
    
}

-(void) revealSideMenu
{
    
    [RDCampusBuddyAppDelegate showSideMenuWithDelegate:self];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    
    [sidebar dismissAnimated:YES completion:nil];
    
    if([[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index] isEqualToString:TIME_TABLE_VIEW_CONTROLLER_TAG]) return;
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UIViewController * uvc = [board instantiateViewControllerWithIdentifier:[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index]];
    
    UINavigationController * s = self.navigationController;
    
    
    
    [self.navigationController setViewControllers:[[NSArray alloc] initWithObjects:uvc, nil] animated:NO];
    
    
    // [self.navigationController pushViewController:uvc animated:YES];
    
    NSLog(@"COUNT %d",[[s viewControllers] count]);
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
    
    NSString * subjectName = [RDUtility getObjectForKey:[NSString stringWithFormat:@"%i",i] fromDictionaryWithKey:@"TT"];
    
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
