//
//  DORadioTransmissionModel.h
//  Antenna
//
//  Created by Paweł Ksieniewicz on 14.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"
#import "DOMath.h"

@interface SignalRangeModel : NSObject

@property (nonatomic, retain) NSArray *channels;
@property (nonatomic, retain) NSSet *receivableChannelsSet;

- (void) calculate;

@end