//
//  ContactsTableViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "RDDataAccess.h"
#import "ContactDetails.h"
#import "ContactSubCategory.h"
#import "ContactDetailTableViewController.h"
#import "RDUtility.h"
#import "RDDatabaseHelper.h"
@interface ContactsTableViewController ()

@property NSArray * contactList;
@property (nonatomic)  NSMutableArray * filterContactList;
@property UIActivityIndicatorView * spinner;
@property NSArray* indexArray;

-(void) didPopulateData:(id) data;
-(void) populateData;
-(void) initialize;

@end

@implementation ContactsTableViewController

@synthesize category = _category;
@synthesize filterContactList = _filterContactList;
@synthesize contactList = _contactList;
@synthesize spinner = _spinner;
@synthesize indexArray = _indexArray;

-(void)didPopulateData:(id)data
{
    self.contactList = [[NSArray alloc] initWithArray:[data objectForKey:@"contacts"]];
    self.indexArray = [[NSArray alloc] initWithArray:[data objectForKey:@"indices"]];
    [self.tableView reloadData];
    [self.spinner stopAnimating];

    
}

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

    
    [self initialize];
    
    
    [self populateData];
    
    
    
}

-(void)initialize
{
    self.title = self.category.categoryName;
    
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //View Initialization
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
    
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    
    
     self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table.png"]];
    self.searchDisplayController.searchResultsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table.png"]];
    
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = [RDUtility centerPointOfScreen];
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];

}

-(void)populateData
{
    
    __weak ContactsTableViewController * weakSelf = self;
    
   [RDUtility executeBlock:^NSDictionary *{
       
       NSArray * arr = [RDDatabaseHelper getContactSubCategoryListForId:weakSelf.category.categoryId];
       
       NSMutableArray * dexArray = [[NSMutableArray alloc] init];
       
       for(int i=0;i<[arr count] ;i++)
       {
           NSString *letterString = [[[arr objectAtIndex:i] subCategoryName] substringToIndex:1];
           if(![dexArray containsObject:letterString])
           {
               [dexArray addObject:letterString];
           }
       }
       
       NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"contacts",dexArray,@"indices", nil];
       
       return dic;
       
   } target:weakSelf selector:@selector(didPopulateData:)];
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

    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.numberOfLines = 2;
    
    cell.backgroundColor = [UIColor clearColor];
    
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
   // self.contactList = nil;
    
   // self.filterContactList = nil;
    
   // self.indexArray = nil;
}

@end
