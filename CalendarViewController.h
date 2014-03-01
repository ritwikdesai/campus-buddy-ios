//
//  CalendarViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 29/09/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarDelegate.h"
#import "CKCalendarViewController.h"
#import "CKCalendarDataSource.h"
#import "SWRevealViewController.h"

#import "RDVCalendarViewController.h"
//@interface CalendarViewController : UIViewController<CKCalendarViewDataSource,CKCalendarViewDelegate,SWRevealViewControllerDelegate>

@interface CalendarViewController : RDVCalendarViewController<SWRevealViewControllerDelegate>


@end
