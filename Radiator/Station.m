//
//  Station.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import "Station.h"

@implementation Station

+ (Station *)stationWithLine:(NSString *)line{
    Station *station = [[Station alloc] init];
    NSArray *componnents = [line componentsSeparatedByString:@";"];
    if (componnents.count == 6) {
        station.name = [componnents objectAtIndex:0];
        station.URL = [NSURL URLWithString:[componnents objectAtIndex:1]];
        station.description = [componnents objectAtIndex:2];
        station.artworkName = [componnents objectAtIndex:3];
        station.category = [componnents objectAtIndex:4];
    }
    else{
        NSLog(@"ERROR");
    }
    return station;
}


@end
