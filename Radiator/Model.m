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
        _stations = [NSArray arrayWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"stations.plist"]];
        _favouriteStations = [[NSArray alloc] init];
        NSLog(@"SC: %i", self.stations.count);

    }
    return self;
}

- (void) fillSections{
    _favouriteStations = [[NSArray alloc] init];
    for (NSDictionary *station in _stations) {
        NSString *identifier = [NSString stringWithFormat:@"%@:%@", [station objectForKey:@"name"], [station objectForKey:@"description"]];
        if ([Favourites isFavourite:identifier]) {
            _favouriteStations = [_favouriteStations arrayByAddingObject:station];
        }
    }    
}

- (void) importStationsFromServer{
    NSLog(@"Import started");
    
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"stations.plist"];
    NSString *defaultDatabasePath = [[NSBundle mainBundle] pathForResource:@"stations" ofType:@"plist"];
    
    // Copy default database
    if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath]) [[NSArray arrayWithContentsOfFile:defaultDatabasePath] writeToFile:databasePath atomically:YES];
    
    NSMutableArray *database = [[NSMutableArray alloc] init];
    
    NSString *csvString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://ksienie.com/radiator/stacje.csv"] encoding:NSUTF8StringEncoding error:nil];
    if (csvString) {
        NSArray *lines = [csvString componentsSeparatedByString:@"\n"];
        NSMutableArray *stations = [[NSMutableArray alloc] init];
        
        for (NSString *line in lines)
            if (![[line substringToIndex:1] isEqualToString:@"#"])
                [stations addObject:line];
        
        for (NSString *station in stations) {
            Station *station = [Station stationWithLine:station];
            NSLog(@"ST: %@", station);
            [database addObject:station];
        }
        if (database.count){
            BOOL error = ![database writeToFile:databasePath atomically:YES];
            NSLog(@"ERROR? [%i]", error);
            //NSLog(@"Database: %@", database);
        }
    }
}

@end
