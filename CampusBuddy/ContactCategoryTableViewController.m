//
//  ContactCategoryTableViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "ContactCategoryTableViewController.h"
#import "RDCampusBuddyAppDelegate.h"
#import "ContactCategory.h"
#import "ContactsTableViewController.h"
#import "RDUtility.h"
#import "ContactCategory.h"
#import "RDDatabaseHelper.h"
@interface ContactCategoryTableViewController ()

@property NSArray* contactList;
@property (nonatomic)  NSMutableArray* filterContactList;
@property UIActivityIndicatorView * spinner;
@property NSArray * indexArray;

-(void) didPopulateData:(id) data;

-(void) initialize;
-(void) populateData;

@end

@implementation ContactCategoryTableViewController

@synthesize contactList = _contactList;
@synthesize filterContactList = _filterContactList;
@synthesize sidebarButton = _sidebarButton;
@synthesize spinner = _spinner;
@synthesize indexArray = _indexArray;


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

//
//-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
//{
//    if(position == FrontViewPositionRight) self.view.userInteractionEnabled = NO;
//    else self.view.userInteractionEnabled = YES;
//}


-(void)didPopulateData:(id)data
{
    
    self.contactList = [[NSArray alloc] initWithArray:[data objectForKey:@"contacts"]];
    NSLog(@"%i",[self.contactList count]);
    self.indexArray = [[NSArray alloc] initWithArray:[data objectForKey:@"indices"]];
    [self.tableView reloadData];
    [self.spinner stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
    
    [self populateData];
   
}

-(void)initialize
{
    _sidebarButton.target = self;
    _sidebarButton.action = @selector(revealSideMenu);
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.revealViewController.delegate = self;
    
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"menu.png"];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    
    //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table.png"]];
  //  self.searchDisplayController.searchResultsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table.png"]];
    
    if([RDUtility isIOS7orLater]) self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    
    
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = [RDUtility centerPointOfScreen];
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    

}

-(void)populateData
{
    [RDUtility executeBlock:^NSDictionary *{
        
        NSArray* arr = [RDDatabaseHelper getContactCategoryList];
    
        NSMutableArray * dexArray = [[NSMutableArray alloc] init];
        
        for(int i=0;i<[arr count] ;i++)
        {
            NSString *letterString = [[[arr objectAtIndex:i] categoryName] substringToIndex:1];
                if(![dexArray containsObject:letterString])
                {
                    [dexArray addObject:letterString];
                }
        }
        
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"contacts",dexArray,@"indices", nil];
        
        return dic;
        
    } target:self selector:@selector(didPopulateData:)];
    
}

#pragma mark - Indexing

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.searchDisplayController.active) return nil;
    return self.indexArray;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    for (int i = 0; i< [self.contactList count]; i++) {
        
        NSString *letterString = [[[self.contactList objectAtIndex:i] categoryName] substringToIndex:1];
        if ([letterString isEqualToString:title]) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return i;
        }
    }
    
    return 0;
}


-(void) revealSideMenu
{
    
    [RDCampusBuddyAppDelegate showSideMenuWithDelegate:self];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    
    [[RDCampusBuddyAppDelegate appDelegateInstance] sidebar:sidebar didTapItemAtIndex:index controller:self segueAutomatically: ![[[RDCampusBuddyAppDelegate viewControllerIdentifiers] objectAtIndex:index] isEqualToString:CONTACTS_VIEW_CONTROLLER_TAG]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filterContactList count];
        
    } else {
        return [self.contactList count];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    [cell setBackgroundColor:[UIColor clearColor]];
  
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
//        NSComparisonResult result = [category.categoryName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch|NSLiteralSearch) range:NSMakeRange(0, [searchText length])];
//      
//        if (result == NSOrderedSame)
//        {
//            [self.filterContactList addObject:category];
//        }
        
        NSRange nameRange = [category.categoryName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if(nameRange.location != NSNotFound)[self.filterContactList addObject:category];

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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   // self.contactList = nil;
   // self.filterContactList = nil;
   // self.indexArray = nil;
}

-(void)dealloc
{
    
}

@end
