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
        self.receivableFreqChannels = [[NSMutableArray alloc] init];
        transmitters = [[NSSet setWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"database" ofType:@"plist"]]] allObjects];        
        freqChannels = [[NSMutableArray alloc] init];
        allMedia = [[NSMutableSet alloc] init];
        
        for (DOTransmitter *transmitter in transmitters) [freqChannels addObjectsFromArray:transmitter.freqChannels];
        for(DOFreqChannel *freqChannel in freqChannels) [allMedia addObject:freqChannel.media];

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
    for(DOFreqChannel *freqChannel in freqChannels) [freqChannel setReception:
                                                     [DOMath receptionWithFreqChannel:freqChannel
                                                                           atDistance:[Reciever.sharedObject.coordinates distanceFromLocation:freqChannel.transmitter.coordinates]]];
    // Filter via codec
    self.receivableFreqChannels =[NSMutableArray arrayWithArray:[freqChannels filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DOFreqChannel *freqChannel, NSDictionary *bind){return freqChannel.codec & [Reciever sharedObject].codec;}]]];
    
    [self.receivableFreqChannels filterUsingPredicate:[NSPredicate predicateWithFormat:@"reception > %f", -30.]];
    [self.receivableFreqChannels sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"reception" ascending:NO]]];
    
    for (NSString *media in allMedia) {
        NSArray *duplicates = [self.receivableFreqChannels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"media == %@", media]];
        if (duplicates.count) [self.receivableFreqChannels removeObjectsInArray:[duplicates objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, duplicates.count-1)]]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"calculated"
                                                        object:nil];
}

@end