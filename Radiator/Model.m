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
        [self loadData];
        _currentStation = nil;
    }
    return self;
}

- (void) loadData{
    if (![[NSFileManager defaultManager] fileExistsAtPath:DB_FILE])
        [NSKeyedArchiver archiveRootObject:[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"stations"
                                                                                                                      ofType:@"plist"]]
                                    toFile:DB_FILE];
    
    _stations = [NSKeyedUnarchiver unarchiveObjectWithFile:DB_FILE];
    
    _favouriteStations = [[NSArray alloc] init];
    for (Station *station in _stations) {
        if ([Favourites isFavourite:station.identifier]) {
            _favouriteStations = [_favouriteStations arrayByAddingObject:station];
        }
    }
}

- (void) filterWithString:(NSString *)string{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", string];
    _filteredStations = [_stations filteredArrayUsingPredicate:predicate];
    _filteredFavouriteStations = [_favouriteStations filteredArrayUsingPredicate:predicate];    
}

- (void) importStationsFromServer {
    NSMutableArray *database = [[NSMutableArray alloc] init];
    
    NSString *csvString = [NSString stringWithContentsOfURL:[NSURL URLWithString:DB_URL] encoding:NSUTF8StringEncoding error:nil];
    if (csvString) {
        NSArray *lines = [csvString componentsSeparatedByString:@"\n"];
        NSMutableArray *stations = [[NSMutableArray alloc] init];
        
        for (NSString *line in lines)
            if (![[line substringToIndex:1] isEqualToString:@"#"])
                [stations addObject:line];
        
        for (NSString *line in stations) {            
            Station *station = [Station stationWithLine:line];
            [database addObject:station];
        }
        
        if (database.count) [NSKeyedArchiver archiveRootObject:database
                                                        toFile:DB_FILE];
    }
}

- (void)setCurrentStation:(Station *)currentStation{
    _currentStation = currentStation;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setPlayer:[[AVPlayer alloc] initWithURL:currentStation.URL]];

}

@end
