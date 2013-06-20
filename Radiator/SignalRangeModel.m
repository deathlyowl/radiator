//
//  DORadioTransmissionModel.m
//  Antenna
//
//  Created by Paweł Ksieniewicz on 14.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "SignalRangeModel.h"
#import "Reciever.h"

@implementation SignalRangeModel

- (id)init
{
    if (self = [super init])
    {
        NSError *error;
        NSData *JSONData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[API_URL stringByAppendingString:@"/channels.json"]]];
        
        if (JSONData) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:JSONData
                                                                 options:kNilOptions
                                                                   error:&error];
            if (!error)
            {
                _channels = [[NSArray alloc] init];
                for (NSDictionary *dictionary in json){
                    Channel *channel = [[Channel alloc] init];
                    channel.frequency = ((NSString *)[dictionary objectForKey:@"frequency"]).floatValue;
                    channel.power = ((NSString *)[dictionary objectForKey:@"power"]).intValue;
                    channel.media = [dictionary objectForKey:@"name"];
                    
                    [channel setCoordinatesWithLat:[dictionary objectForKey:@"longitude"]
                                            andLon:[dictionary objectForKey:@"latitude"]];

                    _channels = [_channels arrayByAddingObject:channel];
                }
                if (_channels.count) [NSKeyedArchiver archiveRootObject:_channels
                                                                toFile:DB_FILE];
            }
        }        
        _receivableChannelsSet = [[NSSet alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(calculate)
                                                     name:@"locationDidChanged"
                                                   object:nil];
    }
    return self;
}

- (void) calculate
{    
    // Refresh reception
    for(Channel *channel in _channels) [channel setReception:
                                        [DOMath receptionWithChannel:channel
                                                          atDistance:[Reciever.sharedObject.coordinates
                                                                      distanceFromLocation:channel.coordinates]]];
    
    NSArray *receiveableChannels = [_channels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"reception > %f", -30.]];
    _receivableChannelsSet = [[NSSet alloc] init];

    for (Channel *channel in receiveableChannels) {
        _receivableChannelsSet = [_receivableChannelsSet setByAddingObject:channel.media];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"calculated"
                                                        object:nil];
    
    NSLog(@"RC: %i/%i : %@", _receivableChannelsSet.count, _channels.count, _receivableChannelsSet);
}

@end