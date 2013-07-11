//
//  ContactCategoryTableViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCategoryTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
