//
//  AboutUsViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 29/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SWRevealViewController.h"
@interface AboutUsViewController ()
@property NSArray * sectionArray;
@property NSArray * rowArray;
@property NSArray * imageArray;
@end

@implementation AboutUsViewController
@synthesize sectionArray = _sectionArray;
@synthesize rowArray = _rowArray;

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
    
    self.title = @"About Us";
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    self.imageArray = @[@[@"rvd.jpg",@"aps.jpg"],@[@"ss.jpg",@"aj.jpg",@"pg.jpg",@"sb.jpg",@"san.jpg",@"ma.jpg",@"mb.jpg"]];

    self.sectionArray = @[@"Campus Buddy Developers",@"Other Developers"];
    self.rowArray = @[@[@"Ritwik Desai",@"Angad Pal Singh Bhatia"],@[@"Shikhar Shrivastav",@"Abhinav Jain",@"Prakhar Gupta",@"Sumit Badwal",@"Sandeep Sandha",@"Mohit Agarwal",@"Mustafa Baquari"]];
         [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
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
    return [self.sectionArray count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionArray objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [[self.rowArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[self.rowArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
   
    if(indexPath.section == 0) cell.detailTextLabel.text = @"CSI 3rd year";
    else if(indexPath.section == 1 && indexPath.row ==0) cell.detailTextLabel.text = @"Alumni";
    else if(indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2))cell.detailTextLabel.text = @"CSI 4th year";
    else if(indexPath.section==1 &&(indexPath.row == 3 || indexPath.row == 4)) cell.detailTextLabel.text = @"CSE 4th year";
    else cell.detailTextLabel.text = @"EE 4th year";
    
    cell.imageView.image = [UIImage imageNamed:[[self.imageArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    return cell;
}



@end
