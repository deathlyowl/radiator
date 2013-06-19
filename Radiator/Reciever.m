//
//  DOReciever.m
//  Anteny
//
//  Created by Paweł Ksieniewicz on 14.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "Reciever.h"

@implementation Reciever
@synthesize gain, codec, locationManager;

+ (Reciever *) sharedObject {
    static dispatch_once_t once;
    static Reciever *sharedObject;
    dispatch_once(&once, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (id)init{
    if (self = [super init]) {
        counter = 0;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    counter++;
    if ([newLocation distanceFromLocation:oldLocation]) {
        [self setCoordinates:newLocation];
        [self setCoordinate:newLocation.coordinate];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationDidChanged"
                                                            object:newLocation];
    }
    if (counter == 5) {
        [manager stopUpdatingLocation];
        counter = 0;
    }
}

@end