//
//  MapPoint.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapPlace.h"

@interface MapPoint : MapPlace

@property (readonly) CGPoint point;

-(id) initWithPoint:(CGPoint) point andName:(NSString*) name;

@end
