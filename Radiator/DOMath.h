//
//  DOMath.h
//  Antenna
//
//  Created by Paweł Ksieniewicz on 15.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"

@interface DOMath : NSObject

+ (float) percentageFromReception:(float)reception;

+ (int) distanceWithPower:(int)power
                     gain:(float)gain
                frequency:(float) frequency
                 andLimit:(float) limit;

+ (float) receptionWithChannel:(Channel *) channel
                    atDistance:(int) distance;

@end