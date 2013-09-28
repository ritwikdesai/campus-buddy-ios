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
@end

@implementation ContactDetailTableViewController

@synthesize subCategory = _subCategory;
@synthesize contact = _contact;
@synthesize filterContactList = _filterContactList;

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

    self.title = self.subCategory.subCategoryName;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIColor *aColor = [UIColor colorWithRed:0.988 green:0.976 blue:0.941 alpha:1.000];
    
    
    self.tableView.backgroundColor = aColor;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithRed:0.988 green:0.976 blue:0.941 alpha:1.000];
    DatabaseHelper* helper =[DatabaseHelper getDatabaseHelper];
    
    BOOL success = NO;
    
    success = [helper openDatabase];
    
    self.contact = [helper getContactDetailListForContactSubCategoryForId:self.subCategory.subCategoryId];
    
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
