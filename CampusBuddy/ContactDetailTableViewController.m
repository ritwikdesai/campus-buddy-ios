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
#import "ContactDetailCell.h"
#import "Util.h"
@interface ContactDetailTableViewController ()

@property NSArray* contact;
@property NSMutableArray* filterContactList;
@property UIActivityIndicatorView * spinner;
@end

@implementation ContactDetailTableViewController

@synthesize subCategory = _subCategory;
@synthesize contact = _contact;
@synthesize filterContactList = _filterContactList;
@synthesize spinner = _spinner;

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.contact.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactDetail";
    ContactDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ContactDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.numberOfLines = 2;
    
    ContactDetails * contactDetail = [self.contact objectAtIndex:indexPath.row];
    
    NSString * title = contactDetail.contactTitle;
    
    //Contact Title
    if(title.length == 0){ cell.contactTitle.text = self.subCategory.subCategoryName;}
    else {cell.contactTitle.text = contactDetail.contactTitle;}
    
    //Phone Number
    
    if(contactDetail.phoneNumber.length !=0){
    cell.phoneLink.text = [Util getDisplayPhoneFromNumber:contactDetail.phoneNumber];
        cell.phoneLink.userInteractionEnabled = YES;
        cell.phoneLink.delegate = self;
        NSRange r = [cell.phoneLink.text rangeOfString:cell.phoneLink.text];
        NSURL * url = [Util getPhoneURLForNumber:contactDetail.phoneNumber];
       [cell.phoneLink addLinkToURL:url withRange:r];

    }
    
    //Email
    
    if(contactDetail.mail.length !=0){
        
        cell.emailLink.text = [Util getEmailAddress:contactDetail.mail];
        cell.emailLink.userInteractionEnabled = YES;
        cell.emailLink.delegate = self;
        NSRange r = [cell.emailLink.text rangeOfString:cell.emailLink.text];
        NSURL * url = [Util getEmailAddressURL:contactDetail.mail];
        [cell.emailLink addLinkToURL:url withRange:r];
        
    }
    
    return cell;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}


@end
