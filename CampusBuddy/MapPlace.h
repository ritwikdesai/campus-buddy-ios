//
//  MapPlace.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 12/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapPlace : NSObject

@property (readonly) NSNumber * placeId;

@property (readonly) NSString* placeName;

-(id)initWithPlaceName: (NSString *) name andPlaceId:(NSNumber *) Id;

@end
