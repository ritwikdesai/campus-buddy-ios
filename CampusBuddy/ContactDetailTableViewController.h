//
//  ContactDetailTableViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactSubCategory.h"

@interface ContactDetailTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property ContactSubCategory * subCategory;
@end
