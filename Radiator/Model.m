//
//  Model.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import "Model.h"
#import "Favourites.h"
#import "Station.h"

@implementation Model

+ (Model *) sharedModel
{
    static dispatch_once_t once;
    static Model *sharedModel;
    dispatch_once(&once, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

- (id)init{
    if (self = [super init]) {
        // Load default database if there's no file in docs
        if (![[NSFileManager defaultManager] fileExistsAtPath:DB_FILE])
            [NSKeyedArchiver archiveRootObject:[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"stations"
                                                                                                                          ofType:@"plist"]]
                                        toFile:DB_FILE];
        [self loadData];
        _currentStation = nil;
    }
    return self;
}

- (void) loadData{
    // Load stations
    _stations = [NSKeyedUnarchiver unarchiveObjectWithFile:DB_FILE];
    
    // Sort stations    
    _stations = [_stations sortedArrayUsingComparator:^NSComparisonResult(Station *a, Station *b) {
        return [a compare:b];
    }];
    
    // Build favourites
    _favouriteStations = [[NSArray alloc] init];
    for (Station *station in _stations)
        if ([Favourites isFavourite:station.identifier])
            _favouriteStations = [_favouriteStations arrayByAddingObject:station];
}

- (void) filterWithString:(NSString *)string{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@ OR description contains[c] %@", string, string];
    _filteredStations = [_stations filteredArrayUsingPredicate:predicate];
    _filteredFavouriteStations = [_favouriteStations filteredArrayUsingPredicate:predicate];    
}

- (void) importStationsFromServer {
    NSError *error;
    NSString *csvString = [NSString stringWithContentsOfURL:[NSURL URLWithString:DB_URL]
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
    if (!error)
    {
        NSArray *lines = [[csvString componentsSeparatedByString:@"\n"]
                          filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"not SELF BEGINSWITH '#'"]],
                *stations = [[NSArray alloc] init];
        
        for (NSString *line in lines) stations = [stations arrayByAddingObject:[Station stationWithLine:line]];
        
        if (stations.count) [NSKeyedArchiver archiveRootObject:stations
                                                        toFile:DB_FILE];
    }
}

- (void)setCurrentStation:(Station *)currentStation{
    _currentStation = currentStation;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setPlayer:[[AVPlayer alloc] initWithURL:currentStation.URL]];

}

@end
