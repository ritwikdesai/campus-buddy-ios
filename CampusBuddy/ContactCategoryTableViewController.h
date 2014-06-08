//
//  ContactCategoryTableViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SWRevealViewController.h"
#import "RNFrostedSidebar.h"
@interface ContactCategoryTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,RNFrostedSidebarDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
