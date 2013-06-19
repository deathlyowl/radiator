//
//  DOGeoObject.m
//  Antenna
//
//  Created by Paweł Ksieniewicz on 26.01.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import "GeoObject.h"

@implementation GeoObject

@synthesize coordinates, coordinate, pointer;

- (void) setCoordinatesWithLat:(NSString *)lat andLon:(NSString *)lon{
    coordinates = [[CLLocation alloc] initWithLatitude:lat.floatValue longitude:lon.floatValue];
}

- (id)init{
    if (self = [super init]) {
        pointer = self;
    }
    return self;
}

@end