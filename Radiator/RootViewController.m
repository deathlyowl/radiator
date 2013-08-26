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
    model = [[Model alloc] init];
    isSearching = NO;
    [super viewDidLoad];
    if (model.favouriteStations.count)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"nearbyReloaded" object:nil];
    
    [_banner setFrame:CGRectMake(0, self.navigationController.view.frame.size.height-50, 320, 50)];
}

- (void)viewDidAppear:(BOOL)animated{
    [_banner setDelegate:self];
}

- (void) reloadTable{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                  withRowAnimation:UITableViewRowAnimationFade];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [model filterWithString:searchString];
    return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationSlide];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationSlide];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    isSearching = NO;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    isSearching = YES;
}

#pragma mark - iAD

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView animateWithDuration:5
                     animations:^{[self.navigationController.view addSubview:_banner];}
                     completion:nil];
    NSLog(@"DLA");
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"FTLA");
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Station *station = [self stationForIndexPath:indexPath];
    
    NSString *identifier = station.category;
    
    if (indexPath.section == 0) identifier = @"lovely";
    if (indexPath.section == 1) identifier = @"nearby";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    
    [cell.textLabel setText:station.name];
    [cell.detailTextLabel setText:station.description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Station *station = [self stationForIndexPath:indexPath];
    if (station != model.currentStation) {
        if (Player.isPlaying) [Player pause];
        model.currentStation = station;
        [Player play];
        self.navigationItem.rightBarButtonItem = self.pauseButton;
    }
    
    self.navigationItem.leftBarButtonItem = [self barButtonForStation:station];
    
    [_titleButton setTitle:station.name
                  forState:UIControlStateNormal];
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

#pragma mark - Actions

- (IBAction)pause:(id)sender {
    self.navigationItem.rightBarButtonItem = self.playButton;
    [Player pause];
}

- (IBAction)play:(id)sender {
    self.navigationItem.rightBarButtonItem = self.pauseButton;
    [Player play];
}

- (UIBarButtonItem *) barButtonForStation:(Station *)station{
    if ([Favourites isFavourite:station.identifier])
        return _unHeartButton;
    else
        return _heartButton;
}

- (IBAction)love:(id)sender {    
    if (![Favourites isFavourite:model.currentStation.identifier])
        [Favourites addToFavourites:model.currentStation.identifier];
    else
        [Favourites removeFavourite:model.currentStation.identifier];
    
    [Favourites saveFavourites];
    
    [model loadData];
        
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.navigationItem.leftBarButtonItem = [self barButtonForStation:model.currentStation];
}

- (IBAction)action:(id)sender {    
    if (model.currentStation){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:model.currentStation.name
                                      delegate:self
                                      cancelButtonTitle:@"Anuluj"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Zgłoś niedziałający stumień", @"Zaproponuj stację", nil];
        [actionSheet showInView:self.view.superview];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Anuluj"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Zaproponuj stację", nil];
        [actionSheet showInView:self.view.superview];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Dziękuję!"
                                                      message:@"Przepraszam, że nie możesz słuchać tego strumienia. Postaram się go naprawić w przeciągu 24 godzin."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    switch (buttonIndex + !(BOOL)model.currentStation) {
        case 0:
            [message show];
            break;
        case 1:
            [self performSegueWithIdentifier:@"propose"
                                      sender:nil];
            break;
    }
}

@end
