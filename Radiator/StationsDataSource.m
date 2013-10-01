//
//  StationsDataSource.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 26.08.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import "StationsDataSource.h"

@implementation StationsDataSource
@synthesize isSearching;

- (id)init{
    if (self = [super init]) {
        isSearching = NO;
        model = [[Model alloc] init];
    }
    return self;
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching) switch (section) {
        case 0: return model.filteredFavouriteStations.count;
        case 1: return model.filteredNearbyStations.count;
        case 2: return model.filteredStations.count;
    }
    else switch (section) {
        case 0: return model.favouriteStations.count;
        case 1: return model.nearbyStations.count;
        case 2: return model.stations.count;
    }
    return 0;
}


- (Station *) stationForIndexPath:(NSIndexPath *)indexPath{
    if (isSearching) {
        switch (indexPath.section) {
            case 0: return [model.filteredFavouriteStations objectAtIndex:indexPath.row];
            case 1: return [model.filteredNearbyStations objectAtIndex:indexPath.row];
            case 2: return [model.filteredStations objectAtIndex:indexPath.row];
        }
    }
    else{
        switch (indexPath.section) {
            case 0: return [model.favouriteStations objectAtIndex:indexPath.row];
            case 1: return [model.nearbyStations objectAtIndex:indexPath.row];
            case 2: return [model.stations objectAtIndex:indexPath.row];
        }
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (isSearching) {
        switch (section) {
            case 0:
                if(model.filteredFavouriteStations.count)
                    return [NSString stringWithFormat:@"Ulubione (%i)", model.filteredFavouriteStations.count];
                else
                    return nil;
            case 1:
                if(model.filteredNearbyStations.count)
                    return [NSString stringWithFormat:@"W okolicy (%i)", model.filteredNearbyStations.count];
                else
                    return nil;
            case 2:
                return [NSString stringWithFormat:@"Wszystkie (%i)", model.filteredStations.count];
        }
    }
    else{
        switch (section) {
            case 0: if(model.favouriteStations.count) return @"Ulubione"; else return nil;
            case 1: if(model.nearbyStations.count) return @"W okolicy"; else return nil;
            case 2: if(model.nearbyStations.count || model.favouriteStations.count) return @"Wszystkie"; else return nil;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Station *station = [self stationForIndexPath:indexPath];
    
    NSString *identifier = station.category;
    
    if (indexPath.section == 0) identifier = @"lovely";
    if (indexPath.section == 1) identifier = @"nearby";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    
    [cell.textLabel setText:station.name];
    [cell.detailTextLabel setText:station.description];
    
    return cell;
}

@end
