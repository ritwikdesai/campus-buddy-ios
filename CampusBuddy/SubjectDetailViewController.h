//
//  SubjectDetailViewController.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 13/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectCell.h"
#import "TimeTableDelegate.h"
@interface SubjectDetailViewController : UIViewController<UITextFieldDelegate>

@property SubjectCell * cell;
@property id<TimeTableDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *textView;
- (IBAction)done:(id)sender;

@end
