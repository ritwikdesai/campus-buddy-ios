//
//  PlacesViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "PlacesViewController.h"
#import "RDDataAccess.h"
#import "MapPlace.h"
#import "RDUtility.h"
#import "RDDatabaseHelper.h"
#import "MapDetailViewController.h"
@interface PlacesViewController ()

@property NSArray* placelist;
@property (nonatomic)  NSMutableArray* filterplacelist;
@property NSArray* indexArray;

-(void) populateData;
-(void)didPopulateData:(id) data;
@end

@implementation PlacesViewController

@synthesize placelist = _placelist;
@synthesize filterplacelist = _filterplacelist;
@synthesize indexArray = _indexArray;

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


-(void)didPopulateData:(id)data
{
    self.placelist = [[NSArray alloc] initWithArray:[data objectForKey:@"places"]];
    self.indexArray = [[NSArray alloc] initWithArray:[data objectForKey:@"indices"]];
    
    [[self tableView] reloadData];
}

-(void)populateData
{
    [RDUtility executeBlock:^NSDictionary *{
//        
//        RDDataAccess * helper = [RDDataAccess getDatabaseHelper];
//        [helper openDatabase];
        
        NSArray* arr = [RDDatabaseHelper getMapPlacesList];
        
        //[helper closeDatabase];
        
        NSMutableArray * dexArray = [[NSMutableArray alloc] init];
        
        for(int i=0;i<[arr count] ;i++)
        {
            NSString *letterString = [[[arr objectAtIndex:i] placeName] substringToIndex:1];
            if(![dexArray containsObject:letterString])
            {
                [dexArray addObject:letterString];
            }
        }
        
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"places",dexArray,@"indices", nil];
        
        return dic;
        
    } target:self selector:@selector(didPopulateData:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Places";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);

    [self populateData];
    
    
}

#pragma mark - Indexing

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.searchDisplayController.active) return nil;
    return self.indexArray;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    for (int i = 0; i< [self.placelist count]; i++) {
        // Here you return the name i.e. Honda,Mazda
        // and match the title for first letter of name
        // and move to that row corresponding to that indexpath as below
        NSString *letterString = [[[self.placelist objectAtIndex:i] placeName ] substringToIndex:1];
        if ([letterString isEqualToString:title]) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return i;
        }
    }
    
    return 0;
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
