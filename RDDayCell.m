//
//  RDDayCell.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 01/03/14.
//  Copyright (c) 2014 Ritwik Desai. All rights reserved.
//

#import "RDDayCell.h"

@implementation RDDayCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _notificationView = [[UIView alloc] init];
        [_notificationView setBackgroundColor:[UIColor blueColor]];
        [_notificationView setHidden:YES];
        [self.contentView addSubview:_notificationView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize viewSize = self.contentView.frame.size;
    
    [[self notificationView] setFrame:CGRectMake(viewSize.width - 10, 0, 10, 10)];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [[self notificationView] setHidden:YES];
}

@end
