//
//  CalendarViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 29/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"
@interface CalendarViewController : UIViewController<CKCalendarViewDataSource,CKCalendarViewDelegate>


@end
