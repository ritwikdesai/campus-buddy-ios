//
//  PlacesViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "PlacesViewController.h"
#import "DatabaseHelper.h"
#import "MapPlace.h"
#import "MapDetailViewController.h"
@interface PlacesViewController ()

@property NSArray* placelist;
@property (nonatomic)  NSMutableArray* filterplacelist;
@end

@implementation PlacesViewController

@synthesize placelist = _placelist;
@synthesize filterplacelist = _filterplacelist;

-(NSMutableArray *) filterplacelist
{
    if(_filterplacelist == nil) _filterplacelist = [[NSMutableArray alloc] initWithCapacity:90];
    return _filterplacelist;
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
    self.title = @"Places";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);

    DatabaseHelper * helper = [DatabaseHelper getDatabaseHelper];
    [helper openDatabase];
    
    self.placelist = [helper getMapPlacesList];
    [helper closeDatabase];
     
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

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filterplacelist count];
        
    } else {
        return [self.placelist count];
        
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detailFromTable"])
    {
        NSIndexPath * indexPath;
        
        MapPlace * category;
        
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            category = [self.filterplacelist objectAtIndex:indexPath.row];
            
            [segue.destinationViewController setPlace:category];
            
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            category = [self.placelist objectAtIndex:indexPath.row];
            
            [segue.destinationViewController setPlace:category];
        }

        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaceCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.numberOfLines = 2;
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [(MapPlace*)[self.filterplacelist objectAtIndex:indexPath.row] placeName];
        
    }
    else  cell.textLabel.text = [(MapPlace*)[self.placelist objectAtIndex:indexPath.row] placeName];
    
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    [self.filterplacelist removeAllObjects];
    for(MapPlace* category in self.placelist)
    {
        NSComparisonResult result = [category.placeName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        
        if (result == NSOrderedSame)
        {
            [self.filterplacelist addObject:category];
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
    [self performSegueWithIdentifier:@"detailFromTable" sender:self];
}

@end
