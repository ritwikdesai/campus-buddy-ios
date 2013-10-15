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

-(id) initWithPoint:(CGPoint) point andName:(NSString *)name
{
    self = [super initWithPlaceName:name andPlaceId:nil];
   
    if(self){
    
        _point.x = point.x;
    
        _point.y = point.y;
      
    }
    return self;
}
@end
