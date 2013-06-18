//
//  Model.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import "Model.h"

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
    _favouriteStations = [NSArray arrayWithObject:[self.stations objectAtIndex:5]];
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
            NSArray *componnents = [station componentsSeparatedByString:@";"];
            if (componnents.count == 5) {
                [database addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  [componnents objectAtIndex:0], @"name",
                  [componnents objectAtIndex:1], @"URL",
                  [componnents objectAtIndex:2], @"description",
                  [componnents objectAtIndex:3], @"artworkName",
                  [componnents objectAtIndex:4], @"category", nil ]];
            }
        }
        if (database.count) [database writeToFile:databasePath atomically:YES];
    }
}

@end
