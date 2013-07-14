//
//  MapPoint.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint
@synthesize point = _point;
@synthesize placeName= _placeName;
-(id) initWithPoint:(CGPoint) point andName:(NSString *)name
{
    self = [super init];
    if(self){
    _point.x = point.x;
    _point.y = point.y;
        _placeName = name;
        
    }
    return self;
}
@end
