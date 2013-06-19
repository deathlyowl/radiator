//
//  DOTransmitter.h
//  Anteny
//
//  Created by Paweł Ksieniewicz on 14.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//
//  Nadajnik:
//      Obiekt, do którego przypisane są kanały częstotliwości, charakteryzujący
//      się współrzędnymi geograficznymi.
//

#import <Foundation/Foundation.h>
#import "GeoObject.h"

@interface DOTransmitter : GeoObject

@property (nonatomic, retain) NSString *object;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSMutableArray *freqChannels;

@end
