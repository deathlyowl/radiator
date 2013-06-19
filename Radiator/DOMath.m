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

+ (float) frequencyFromChannel:(float)channel
                      forCodec:(short int)codec
{
    switch (codec) {
        case FM:
            return channel;
        case AM:
            return channel / 1000.;
        case TV:
        case MPEG2:
        case MPEG4:
            if (channel >= 21 && channel <= 69)
                return 474. + 8. * (channel - 21.);
            if (channel >= 5 && channel <= 12)
                return 177.5 + 7. * (channel - 5);
        default:
            return 0;
            break;
    }
}

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

+ (float) receptionWithFreqChannel:(DOFreqChannel *)freqChannel
                        atDistance:(int) distance{
    float dBm = 10. * log10(freqChannel.power * 1000);
    float lambda = 300. / [self frequencyFromChannel:freqChannel.frequency forCodec:freqChannel.codec];
    float reception = dBm + [Reciever sharedObject].gain + 20 * log10(lambda / (4 * M_PI * distance));
    //NSLog(@"\nPower: %d [W]\nPower: %.0f [dBm]\nGain: %.1f [dB]\nDistance: %i [m]\nFrequency: %f [mHz]\n---\nReception: %f [dB]\n", power, dBm, gain, distance, frequency, reception);
    return reception;
}

@end