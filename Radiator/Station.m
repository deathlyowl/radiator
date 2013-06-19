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
    station.name = [componnents objectAtIndex:0];
    station.URL = [NSURL URLWithString:[componnents objectAtIndex:1]];
    station.description = [componnents objectAtIndex:2];
    station.artworkName = [componnents objectAtIndex:3];
    station.category = [componnents objectAtIndex:4];
    return station;
}

- (NSString *) comparableName{
    if (_name.length > 11 && [[_name substringToIndex:11] isEqualToString:@"Radio Plus "]) return [_name substringFromIndex:11];
    if (_name.length > 6 && [[_name substringToIndex:6] isEqualToString:@"Radio "]) return [_name substringFromIndex:6];
    if (_name.length > 14 && [[_name substringToIndex:14] isEqualToString:@"Polskie Radio "]) return [_name substringFromIndex:14];

    return _name;
}

- (BOOL) compare:(Station *)theOtherOne{
    if ([self.comparableName caseInsensitiveCompare:theOtherOne.comparableName] == NSOrderedDescending)
        return YES;
    else
        return NO;
}

- (NSString *)identifier{ return [NSString stringWithFormat:@"%@:%@", _name, _description]; }

// Decode
- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super init]) // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
    {
        _name = [decoder decodeObjectForKey:@"name"];
        _URL = [decoder decodeObjectForKey:@"URL"];
        _description = [decoder decodeObjectForKey:@"description"];
        _artworkName = [decoder decodeObjectForKey:@"artworkName"];
        _category = [decoder decodeObjectForKey:@"category"];
    }
    return self;
}

// Encode
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_URL forKey:@"URL"];
    [encoder encodeObject:_description forKey:@"description"];
    [encoder encodeObject:_artworkName forKey:@"artworkName"];
    [encoder encodeObject:_category forKey:@"category"];
}


@end
