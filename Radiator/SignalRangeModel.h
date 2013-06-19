//
//  DORadioTransmissionModel.h
//  Antenna
//
//  Created by Paweł Ksieniewicz on 14.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOTransmitter.h"
#import "DOFreqChannel.h"
#import "DOMath.h"

@interface SignalRangeModel : NSObject {
    NSMutableSet *allMedia;
    NSArray *transmitters;
    NSMutableArray *freqChannels;
}

@property (nonatomic, retain) NSMutableArray *receivableFreqChannels;

- (void) calculate;

@end