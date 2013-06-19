//
//  DOTransmitter.m
//  Anteny
//
//  Created by Paweł Ksieniewicz on 14.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "DOTransmitter.h"

@implementation DOTransmitter
@synthesize city, place, object, freqChannels;

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.object forKey:@"object"];
    [coder encodeObject:self.city forKey:@"city"];
    [coder encodeObject:self.place forKey:@"place"];
    [coder encodeObject:self.coordinates forKey:@"coordinates"];
    [coder encodeObject:freqChannels forKey:@"freqChannels"];
}

- (id)initWithCoder:(NSCoder *)coder{
    if(self = [super init])
    {
        self.coordinates = [coder decodeObjectForKey:@"coordinates"];
        
        object = [coder decodeObjectForKey:@"object"];
        city = [coder decodeObjectForKey:@"city"];
        place = [coder decodeObjectForKey:@"place"];
        freqChannels = [coder decodeObjectForKey:@"freqChannels"];
                
        self.coordinate = self.coordinates.coordinate;
        for (DOFreqChannel *freqChannel in self.freqChannels) [freqChannel setTransmitter:self];
    }
    return self;
}

@end
