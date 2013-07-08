//
//  ContactsTableViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCategory.h"
@interface ContactsTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property ContactCategory * category;


@end
