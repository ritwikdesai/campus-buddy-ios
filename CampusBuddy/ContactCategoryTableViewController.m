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
#import "SWRevealViewController.h"
#import "Util.h"
@interface ContactCategoryTableViewController ()

@property NSArray* contactList;
@property (nonatomic)  NSMutableArray* filterContactList;
@property UIActivityIndicatorView * spinner;
@end

@implementation ContactCategoryTableViewController

@synthesize contactList = _contactList;
@synthesize filterContactList = _filterContactList;
@synthesize sidebarButton = _sidebarButton;
@synthesize spinner = _spinner;

-(NSMutableArray *)filterContactList
{
    if(_filterContactList == nil)
    _filterContactList = [[NSMutableArray alloc] init];
    return _filterContactList;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma SWRevealController


-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionRight) self.view.userInteractionEnabled = NO;
    else self.view.userInteractionEnabled = YES;
}

-(void) didReceiveDataFromDatabase:(NSArray *)data
{
    self.contactList = [[NSArray alloc] initWithArray:data];
    [self.tableView reloadData];
    [self.spinner stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //Setup Delegates

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.revealViewController.delegate = self;
    
   [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
   
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = [Util centerPointOfScreen];
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        DatabaseHelper* helper =[DatabaseHelper getDatabaseHelper];
        
        [helper openDatabase];
        
        NSArray* arr = [helper getContactCategoryList];
        
        [helper closeDatabase];
        
        [self performSelectorOnMainThread:@selector(didReceiveDataFromDatabase:) withObject:arr waitUntilDone:YES];
        
    });
   
    
   
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filterContactList count];
        
    } else {
        return [self.contactList count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell;

        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.numberOfLines = 2;
  
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [(ContactCategory*)[self.filterContactList objectAtIndex:indexPath.row] categoryName];
        
    }
  else  cell.textLabel.text = [(ContactCategory*)[self.contactList objectAtIndex:indexPath.row] categoryName];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showContacts"])
    {
        NSIndexPath * indexPath;
        
        ContactCategory * category;
 
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            category = [self.filterContactList objectAtIndex:indexPath.row];
            
            [segue.destinationViewController setCategory:category];
            
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            category = [self.contactList objectAtIndex:indexPath.row];
            
            [segue.destinationViewController setCategory:category];
        }
        
            }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
 
    [self.filterContactList removeAllObjects];
    for(ContactCategory* category in self.contactList)
    {
        NSComparisonResult result = [category.categoryName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
      
        if (result == NSOrderedSame)
        {
            [self.filterContactList addObject:category];
        }
        
    }
    
   
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showContacts" sender:self];
}

@end
