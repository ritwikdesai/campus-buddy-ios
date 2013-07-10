//
//  ContactDetailCell.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 10/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "ContactDetailCell.h"

@implementation ContactDetailCell

@synthesize contactTitle = _contactTitle;
@synthesize phoneLink = _phoneLink;
@synthesize emailLink =_emailLink;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
