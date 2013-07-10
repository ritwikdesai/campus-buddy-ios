//
//  ContactDetailCell.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
@interface ContactDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactTitle;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *phoneLink;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *emailLink;

@end
