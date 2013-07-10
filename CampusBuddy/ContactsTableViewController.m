//
//  ContactsTableViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "DatabaseHelper.h"
#import "ContactDetails.h"
#import "ContactSubCategory.h"
#import "ContactDetailTableViewController.h"
@interface ContactsTableViewController ()

@property NSArray * contactList;
@property (nonatomic)  NSMutableArray * filterContactList;
@end

@implementation ContactsTableViewController

@synthesize category = _category;
@synthesize filterContactList = _filterContactList;


-(NSMutableArray*) filterContactList
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //Initialize
    self.title = self.category.categoryName;
    
    
    //Setup Delegates
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    
    DatabaseHelper* helper =[DatabaseHelper getDatabaseHelper];
    
    BOOL success = NO;
    
    success = [helper openDatabase];
    
    self.contactList = [helper getContactSubCategoryListForId:self.category.categoryId];
    
    success = [helper closeDatabase];
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filterContactList count];
        
    } else {
        return [self.contactList count];
        
    }}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"ContactCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    cell.textLabel.text = [(ContactSubCategory*)[self.contactList objectAtIndex:indexPath.row] subCategoryName];
//    
//    return cell;
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.numberOfLines = 2;
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [(ContactSubCategory*)[self.filterContactList objectAtIndex:indexPath.row] subCategoryName];
        
    }
    else  cell.textLabel.text = [(ContactSubCategory*)[self.contactList objectAtIndex:indexPath.row] subCategoryName];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showDetail"])
    {
        NSIndexPath * indexPath;
        
        ContactSubCategory * subCategory;
        
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            subCategory = [self.filterContactList objectAtIndex:indexPath.row];
            
            [segue.destinationViewController setSubCategory:subCategory];
            
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            subCategory = [self.contactList objectAtIndex:indexPath.row];
            
            [segue.destinationViewController setSubCategory:subCategory];
        }
        
    }
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    [self.filterContactList removeAllObjects];
    for(ContactSubCategory* category in self.contactList)
    {
        NSComparisonResult result = [category.subCategoryName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        
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
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

@end
