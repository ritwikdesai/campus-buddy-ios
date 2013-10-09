//
//  MapPlaceDetail.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "MapPlaceDetail.h"

@implementation MapPlaceDetail
@synthesize placeDescription = _placeDescription;
@synthesize telephone = _telephone;
@synthesize mail = _mail;
@synthesize image = _image;

- (id)initWithDescription:(NSString *)placeDescription telephone:(NSString *)tel mail:(NSString *)mail andImage:(NSString *)image
{
    self = [super init];
    if (self) {
        
        _placeDescription = [placeDescription copy];
        _telephone = [tel copy];
        _mail = [mail copy];
        _image = [image copy];
    }
    return self;
}
@end
