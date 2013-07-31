//
//  TTSettingsViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 15/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "TTSettingsViewController.h"
#import "SubjectListViewController.h"
#import "Util.h"
@interface TTSettingsViewController ()

@property NSArray * settingsArray;
@end

@implementation TTSettingsViewController

@synthesize settingsArray = _settingsArray;
@synthesize dataSource = _dataSource;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Settings";
    self.settingsArray = @[@"Subject List",@"Reset Time Table"];
   
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.settingsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.settingsArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectSubjects"]) {
        [segue.destinationViewController setSegueTag:1];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)[ self performSegueWithIdentifier:@"selectSubjects" sender:self];
    if(indexPath.row ==1) {
        [Util removeDictionaryWithKey:@"TT"];
    [self.dataSource reloadTimeTable];
    [self.navigationController popViewControllerAnimated:YES];
        
    }
}

@end
