//
//  TimeTableDelegate.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 13/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubjectCell.h"
@protocol TimeTableDelegate
@optional
-(void) updateTimeTableEntryForTag:(NSInteger) tag withName:(NSString*)name;
-(void) getSubjectName:(NSString*) name forTableCell:(SubjectCell*)cell;
 
@end
