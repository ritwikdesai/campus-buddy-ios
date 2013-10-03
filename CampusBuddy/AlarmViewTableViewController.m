//
//  AlarmViewTableViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 28/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "AlarmViewTableViewController.h"

#import "SubjectListViewController.h"
#import "AlarmCell.h"
@interface AlarmViewTableViewController ()
@property NSArray * cellNames;
@property NSArray * cellTitles;

@end

@implementation AlarmViewTableViewController

@synthesize cellNames = _cellNames;
@synthesize cellTitles = _cellTitles;
@synthesize period = _period;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Alarm";
    
    self.cellNames = @[@"subname",@"datepicker"];
    self.cellTitles = @[@"Subject",@"Alarm"];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showSubjects"])
    {
        [segue.destinationViewController setPeriod:self.period];
        [segue.destinationViewController setSegueTag:2];
        [segue.destinationViewController setDelegate:self];
    }
}

-(void)updateTimeTableEntryForTag:(NSInteger)tag withName:(NSString *)name
{
    
    self.period.periodName = name;
    self.period.tag = tag;
    [self.tableView reloadData];
    
    [self.delegate updateTimeTableEntryForTag:tag withName:name];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [self.cellTitles count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.cellTitles objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) return 60;
    if(indexPath.section == 1) return 290;
    
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *CellIdentifier = [self.cellNames objectAtIndex:indexPath.section] ;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.section ==0 && indexPath.row == 0)cell.textLabel.text = self.period.periodName;
    
    if(indexPath.section == 1 && indexPath.row ==0) {
        
        AlarmCell * aCell =(AlarmCell *) cell;
       
        aCell.period = self.period;
    }
    return cell;
}


@end
