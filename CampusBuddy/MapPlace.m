//
//  MapPlace.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "MapPlace.h"

@implementation MapPlace

@synthesize placeId = _placeId;

@synthesize placeName = _placeName;

-(id)initWithPlaceName: (NSString *) name andPlaceId:(NSNumber *) Id
{
    self = [super init];
    
    if(self)
    {
        _placeId = [Id copy];
        
        _placeName = [name copy];
    }
    
    return self;
}

@end
