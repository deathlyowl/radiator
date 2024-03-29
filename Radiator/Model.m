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

- (id)init{
    if (self = [super init]) {
        antennaDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"antennaDictionary"
                                                                                                       ofType:@"plist"]];
        _nearbySet = [[NSSet alloc] init];
        model = [[SignalRangeModel alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadTable)
                                                     name:@"calculated" object:nil];
        // Load default database if there's no file in docs
        if (![[NSFileManager defaultManager] fileExistsAtPath:DB_FILE])
            [NSKeyedArchiver archiveRootObject:[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"stations"
                                                                                                                          ofType:@"plist"]]
                                        toFile:DB_FILE];
        [self importStationsFromServer];
        [self loadData];
        _currentStation = nil;
    }
    return self;
}

- (void) reloadTable{    
    // Build nearby
    _nearbyStations = [[NSArray alloc] init];
    NSLog(@"_nearbySet: %@", _nearbySet);
    for (Station *station in _stations)
        if ([model.receivableChannelsSet containsObject:station.name])
            _nearbyStations = [_nearbyStations arrayByAddingObject:station];
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"nearbyReloaded"
                                                        object:nil];
}

- (void) loadData{
    // Load stations
    _stations = [NSKeyedUnarchiver unarchiveObjectWithFile:DB_FILE];
    
    // Sort stations    
    _stations = [_stations sortedArrayUsingComparator:^NSComparisonResult(Station *a, Station *b) {
        return [a compare:b];
    }];
    
    NSLog(@"Stations in nearby [%i]", _nearbyStations.count);
    for (Station *station in _nearbyStations) NSLog(@"\t| %@", station.name);
    
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
    _filteredNearbyStations = [_nearbyStations filteredArrayUsingPredicate:predicate];
}

- (void) importStationsFromServer {
    NSError *error;
    
    NSData *JSONData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[API_URL stringByAppendingString:@"/stations.json"]]];

    if (JSONData) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:JSONData
                                                             options:kNilOptions
                                                               error:&error];
        if (!error)
        {
            NSArray *stations = [[NSArray alloc] init];
            for (NSDictionary *dictionary in json)
                stations = [stations arrayByAddingObject:[Station stationWithDictionary:dictionary]];
            if (stations.count) [NSKeyedArchiver archiveRootObject:stations
                                                            toFile:DB_FILE];
        }
    }
}

- (void)setCurrentStation:(Station *)currentStation{
    _currentStation = currentStation;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setPlayer:[[AVPlayer alloc] initWithURL:currentStation.URL]];

}

@end
