//
//  DOFreqChannel.m
//  Anteny
//
//  Created by Paweł Ksieniewicz on 14.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "DOFreqChannel.h"

@implementation DOFreqChannel
@synthesize transmitter, codec, media, power, frequency, reception;

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:codec forKey:@"codec"];
    [coder encodeFloat:frequency forKey:@"frequency"];
    [coder encodeInt:power forKey:@"power"];
    [coder encodeObject:media forKey:@"media"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        codec = [coder decodeIntForKey:@"codec"];
        frequency = [coder decodeFloatForKey:@"frequency"];
        power = [coder decodeIntForKey:@"power"];
        media = [coder decodeObjectForKey:@"media"];
    }
    return self;
}

@end
