//
//  MapPlaceDetail.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapPlaceDetail : NSObject
@property (readonly) NSString* placeDescription;
@property (readonly) NSString* telephone;
@property (readonly) NSString * mail;
@property (readonly) NSString* image;

-(id)initWithDescription:(NSString*)placeDescription telephone:(NSString*)tel mail:(NSString *)mail andImage:(NSString*)image;

@end
