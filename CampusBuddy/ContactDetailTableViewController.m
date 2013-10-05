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
@property NSString * urlString;

@property UIActivityIndicatorView * spinner;

-(void) populateData;
-(void) initialize;

@end

@implementation ContactDetailTableViewController

@synthesize subCategory = _subCategory;
@synthesize contact = _contact;
@synthesize sectionCount = _sectionCount;
@synthesize spinner = _spinner;
@synthesize sectionTitles = _sectionTitles;
@synthesize urlString = _urlString;

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

    
    [self initialize];
    
    [self populateData];
   
    
}

-(void)initialize
{
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
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table.png"]];
    
    self.sectionTitles = @[@"Name",@"Phone Number",@"E-Mail",@"Address"];
}


-(void) populateData
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        DatabaseHelper* helper =[DatabaseHelper getDatabaseHelper];
        
        [helper openDatabase];
        
        NSArray* arr = [helper getContactDetailListForContactSubCategoryForId:self.subCategory.subCategoryId];
        
        [helper closeDatabase];
        
        [self performSelectorOnMainThread:@selector(didReceiveDataFromDatabase:) withObject:arr waitUntilDone:YES];
        
    });
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return [[self.contact objectAtIndex:0] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.contact objectAtIndex:0] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];

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
    
    self.urlString = detail;
    
    if([titleName isEqualToString:@"Phone Number"])
    {
       // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[Util getDialablePhoneFromNumber:detail]]];
        NSMutableString * message = [[NSMutableString alloc] initWithString:@"Do you want to call "];
        [message appendString:[Util getDisplayPhoneFromNumber:detail]];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Call" message:[message copy] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
        
        [alert show];
        
    }
    
    else if([titleName isEqualToString:@"E-Mail"])
    {
        NSMutableString * message = [[NSMutableString alloc] initWithString:@"Do you want to Mail "];
        [message appendString:[Util getEmailAddress:detail]];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mail" message:[message copy] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Compose", nil];
        
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if(buttonIndex == 1)
     {
         NSString * Title = [alertView title];
         
         if([Title isEqualToString:@"Call"])
         {
             [[UIApplication sharedApplication] openURL:[Util getPhoneURLForNumber:self.urlString]];
         }
         
        else if([Title isEqualToString:@"Mail"])
         {
             [[UIApplication sharedApplication] openURL:[Util getEmailAddressURL:self.urlString]];
         }
         
     }
}

@end
