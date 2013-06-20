//
//  DOMath.m
//  Antenna
//
//  Created by Paweł Ksieniewicz on 15.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "DOMath.h"
#import "Reciever.h"
#import <math.h>

@implementation DOMath

+ (float) percentageFromReception:(float)reception
{
    if (reception > 0) return 1;
    float percent = RECEPTION_LIMIT / 100;
    return (100 - (- reception) / percent) / 100;
}

+ (int) distanceWithPower:(int)power
                     gain:(float)gain
                frequency:(float)frequency
                 andLimit:(float) limit
{
    float dBm = 10. * log10(power * 1000);
    float lambda = 300. / (float)frequency;
    int distance = lambda / (4 * M_PI * pow(10,(-limit - dBm - gain)/20));
    return distance;
}

+ (float) receptionWithChannel:(Channel *)channel
                    atDistance:(int) distance{
    float dBm = 10. * log10(channel.power * 1000);
    float lambda = 300. / channel.frequency;
    float reception = dBm + [Reciever sharedObject].gain + 20 * log10(lambda / (4 * M_PI * distance));
    return reception;
}

@end