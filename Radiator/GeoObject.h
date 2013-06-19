//
//  DOGeoObject.h
//  Antenna
//
//  Created by Paweł Ksieniewicz on 26.01.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GeoObject : NSObject

@property (nonatomic, retain) CLLocation *coordinates;

// MapAnnotation
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) id pointer;

- (void) setCoordinatesWithLat:(NSString *)lat
                        andLon:(NSString *)lon;

@end
