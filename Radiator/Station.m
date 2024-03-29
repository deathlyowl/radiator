//
//  Station.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import "Station.h"

@implementation Station

+ (Station *)stationWithDictionary:(NSDictionary *)dictionary{
    Station *station = [[Station alloc] init];
    station.name = [dictionary objectForKey:@"name"];
    station.URL = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
    station.description = [dictionary objectForKey:@"description"];
    station.artworkName = [dictionary objectForKey:@"shortcut"];
    station.category = [dictionary objectForKey:@"genre"];
    station.idNumber = [dictionary objectForKey:@"id"];
    return station;
}

- (NSString *) comparableName{
    if (_name.length > 11 && [[_name substringToIndex:11] isEqualToString:@"Radio Plus "]) return [_name substringFromIndex:11];
    if (_name.length > 6 && [[_name substringToIndex:6] isEqualToString:@"Radio "]) return [_name substringFromIndex:6];
    if (_name.length > 14 && [[_name substringToIndex:14] isEqualToString:@"Polskie Radio "]) return [_name substringFromIndex:14];
    if (_name.length > 17 && [[_name substringToIndex:17] isEqualToString:@"Katolickie Radio "]) return [_name substringFromIndex:17];

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
        _idNumber = [decoder decodeObjectForKey:@"idNumber"];
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
    [encoder encodeObject:_idNumber forKey:@"idNumber"];
}


@end
