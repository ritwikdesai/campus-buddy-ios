//
//  ContactDetailTableViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "ContactDetailTableViewController.h"
#import "DatabaseHelper.h"
#import "ContactDetails.h"

#import "Util.h"
@interface ContactDetailTableViewController ()

@property NSArray* contact;
@property NSInteger sectionCount;
@property NSArray* sectionTitles;

@property UIActivityIndicatorView * spinner;
@end

@implementation ContactDetailTableViewController

@synthesize subCategory = _subCategory;
@synthesize contact = _contact;
@synthesize sectionCount = _sectionCount;
@synthesize spinner = _spinner;
@synthesize sectionTitles = _sectionTitles;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) didReceiveDataFromDatabase:(NSArray *)data
{
    self.contact = [[NSArray alloc] initWithArray:data];
    
    [self.tableView reloadData];
    
    [self.spinner stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.subCategory.subCategoryName;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
   [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
    
    self.spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = [Util centerPointOfScreen];
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];

    self.sectionTitles = @[@"Name",@"Phone Number",@"E-Mail",@"Address"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        DatabaseHelper* helper =[DatabaseHelper getDatabaseHelper];
        
        [helper openDatabase];
        
        NSArray* arr = [helper getContactDetailListForContactSubCategoryForId:self.subCategory.subCategoryId];
        
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
    return [[self.contact objectAtIndex:0] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.contact objectAtIndex:0] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if([[[self.contact objectAtIndex:0] objectAtIndex: indexPath.section] isEqualToString:@"Phone Number"])
    {
             cell.textLabel.text = [Util getDisplayPhoneFromNumber:
                                    [[self.contact objectAtIndex:1]
                                     objectAtIndex: indexPath.section]];
    }
    
    else
    {
       cell.textLabel.text = [[self.contact objectAtIndex:1] objectAtIndex: indexPath.section];
    }
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * titleName = [[self.contact objectAtIndex:0] objectAtIndex:indexPath.section];
    
    NSString * detail = [[self.contact objectAtIndex:1] objectAtIndex:indexPath.section];
    
    if([titleName isEqualToString:@"Phone Number"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[Util getDialablePhoneFromNumber:detail]]];
    }
    
    else if([titleName isEqualToString:@"E-Mail"])
    {
        [[UIApplication sharedApplication] openURL:[Util getEmailAddressURL:detail]];
    }
}



@end
