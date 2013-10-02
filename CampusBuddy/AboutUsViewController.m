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
@property NSArray * fbURLArray;
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

-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionRight) self.view.userInteractionEnabled = NO;
    else self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"About Us";
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    
    self.revealViewController.delegate = self;
    
    self.imageArray = @[@[@"mdg.png"],@[@"rvd.jpg",@"aps.jpg"],@[@"ss.jpg",@"aj.jpg",@"pg.jpg",@"sb.jpg",@"san.jpg",@"ma.jpg",@"mb.jpg"]];

    self.sectionArray = @[@"Mobile Development Group IIT Roorkee",@"Campus Buddy Developers",@"Other Members"];
    self.rowArray = @[@[@"MDG IIT Roorkee "],@[@"Ritwik Desai",@"Angad Pal Singh Bhatia"],@[@"Shikhar Shrivastav",@"Abhinav Jain",@"Prakhar Gupta",@"Sumit Badwal",@"Sandeep Sandha",@"Mohit Agarwal",@"Mustafa Baquari"]];
         [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
    
    self.fbURLArray = @[@[@"https://www.facebook.com/mdgiitr"],@[@"https://www.facebook.com/geekyritwik",@"https://www.facebook.com/angadpal81"],@[@"https://www.facebook.com/shikhar.shrivastav",@"https://www.facebook.com/abhinav.jain.963",@"https://www.facebook.com/prakhariitr",@"https://www.facebook.com/sumitbadwal.iitr",@"https://www.facebook.com/gurmeet.s.sandha",@"https://www.facebook.com/mohitagarwal.iitr",@"https://www.facebook.com/mustafa.baquari"]];
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
    cell.textLabel.numberOfLines = 2;
    
    if(indexPath.section ==0){
        cell.textLabel.textColor = [UIColor blueColor];
    }
    if(indexPath.section ==0) cell.detailTextLabel.text = @"";
    else if(indexPath.section == 1) cell.detailTextLabel.text = @"CSI 3rd year";
    else if(indexPath.section == 2 && indexPath.row ==0) cell.detailTextLabel.text = @"Alumni";
    else if(indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2))cell.detailTextLabel.text = @"CSI 4th year";
    else if(indexPath.section==2 &&(indexPath.row == 3 || indexPath.row == 4)) cell.detailTextLabel.text = @"CSE 4th year";
    else cell.detailTextLabel.text = @"EE 4th year";
    
    cell.imageView.image = [UIImage imageNamed:[[self.imageArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[self.fbURLArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];

}

@end
