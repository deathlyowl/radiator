//
//  DOReciever.h
//  Anteny
//
//  Created by Paweł Ksieniewicz on 14.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//
//  Odbiornik:
//      Obiekt, charakteryzujący się współrzędnymi geograficznymi, wynikającym z
//      anteny odbiorczej zyskiem energetycznym i rodzajem sygnału, który
//      potrafi zdekodować.
//

#import <Foundation/Foundation.h>
#import "GeoObject.h"

@interface Reciever : GeoObject <CLLocationManagerDelegate> {
    int counter;
}

@property (nonatomic) float gain;
@property (nonatomic) short int codec;

@property (nonatomic, retain) CLLocationManager *locationManager;

+ (Reciever *) sharedObject;

@end