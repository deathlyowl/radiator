//
//  RootViewController.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import "RootViewController.h"
#import "Favourites.h"
#import "Station.h"

@implementation RootViewController

- (void)viewDidLoad
{
    isSearching = NO;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [[Model sharedModel] filterWithString:searchString];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    isSearching = NO;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    isSearching = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching) switch (section) {
        case 0: return [Model sharedModel].filteredFavouriteStations.count;
        case 1: return 0;
        case 2: return [Model sharedModel].filteredStations.count;
    }
    else switch (section) {
        case 0: return [Model sharedModel].favouriteStations.count;
        case 1: return 0;
        case 2: return [Model sharedModel].stations.count;
    }
    return 0;
}


- (Station *) stationForIndexPath:(NSIndexPath *)indexPath{
    if (isSearching) {
        switch (indexPath.section) {
            case 0: return [[Model sharedModel].filteredFavouriteStations objectAtIndex:indexPath.row];
            case 1: return [[Model sharedModel].stations objectAtIndex:indexPath.row];
            case 2: return [[Model sharedModel].filteredStations objectAtIndex:indexPath.row];
        }
    }
    else{
        switch (indexPath.section) {
            case 0: return [[Model sharedModel].favouriteStations objectAtIndex:indexPath.row];
            case 1: return [[Model sharedModel].stations objectAtIndex:indexPath.row];
            case 2: return [[Model sharedModel].stations objectAtIndex:indexPath.row];
        }
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (![Model sharedModel].favouriteStations.count) return nil;
    switch (section) {
        case 0: return @"Ulubione";
        case 1: if(0 == 0) return nil; else return @"W okolicy";
        case 2: return @"Wszystkie";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Station *station = [self stationForIndexPath:indexPath];
    
    NSString *identifier = station.category;
    
    if (indexPath.section == 0) identifier = @"lovely";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    
    [cell.textLabel setText:station.name];
    [cell.detailTextLabel setText:station.description];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Station *station = [self stationForIndexPath:indexPath];
    if (station != [Model sharedModel].currentStation) {
        [Player setStation:station];
        [Player play];
        self.navigationItem.rightBarButtonItem = self.pauseButton;
    }
    
    self.navigationItem.leftBarButtonItem = self.heartButton;
    
    [self.navigationItem setTitle:station.name];
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}


- (IBAction)pause:(id)sender {
    self.navigationItem.rightBarButtonItem = self.playButton;
    [Player pause];
}

- (IBAction)play:(id)sender {
    self.navigationItem.rightBarButtonItem = self.pauseButton;
    [Player play];
}

- (IBAction)love:(id)sender {    
    if (![Favourites isFavourite:[Model sharedModel].currentStation.identifier]) {
        [Favourites addToFavourites:[Model sharedModel].currentStation.identifier];
    }
    else{
        [Favourites removeFavourite:[Model sharedModel].currentStation.identifier];
    }
    
    [Favourites saveFavourites];
    
    [[Model sharedModel] loadData];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

@end
