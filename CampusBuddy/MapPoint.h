//
//  MapPoint.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapPoint : NSObject
@property (readonly) CGPoint point;
@property (readonly) NSString* placeName;
-(id) initWithPoint:(CGPoint) point andName:(NSString*) name;
@end
