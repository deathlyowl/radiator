//
//  DOFreqChannel.h
//  Anteny
//
//  Created by Paweł Ksieniewicz on 14.10.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//
//  Kanał częstotliwości:
//      Unikalna w skali nadajnika wartość częstotliwości, charakteryzująca się
//      mocą nadawczą, zasięgiem w odbiorniku i rodzajem kodowania sygnału, na której przykazywany jest
//      kanał lub zbiór kanałów audiowizualnych (multipleks).
//

#import <Foundation/Foundation.h>
#import "DOTransmitter.h"

@interface DOFreqChannel : NSObject

@property (nonatomic, retain) DOTransmitter *transmitter;
@property (nonatomic) short int codec;
@property (nonatomic) float frequency;
@property (nonatomic) float reception;
@property (nonatomic) int power;
@property (nonatomic, retain) NSString *media;

@end
