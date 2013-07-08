//
//  ContactCategoryTableViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "ContactCategoryTableViewController.h"
#import "DatabaseHelper.h"
#import "SDSAppDelegate.h"
#import "ContactCategory.h"
#import "ContactsTableViewController.h"
@interface ContactCategoryTableViewController ()

@property NSArray* contactList;

@end

@implementation ContactCategoryTableViewController

@synthesize contactList = _contactList;

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
    
    //Setup Delegates
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    DatabaseHelper* helper =[DatabaseHelper getDatabaseHelper];
    
    BOOL success = NO;
    
    success = [helper openDatabase];
    
    self.contactList = [helper getContactCategoryList];
    
    success = [helper closeDatabase];
  

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.contactList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [(ContactCategory*)[self.contactList objectAtIndex:indexPath.row] categoryName];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showContacts"])
    {
        NSIndexPath * indexPath = (NSIndexPath*) sender;
        
        ContactCategory * category = [self.contactList objectAtIndex:indexPath.row];
        
        [segue.destinationViewController setCategory:category];
        
            }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showContacts" sender:indexPath];
}

@end
