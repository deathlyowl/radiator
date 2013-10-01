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
    [self.tableView setDataSource:[[StationsDataSource alloc] init]];
    
    [super viewDidLoad];
    
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
#warning search!
//    [model filterWithString:searchString];
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
    [(StationsDataSource *)self.tableView.dataSource setIsSearching:NO];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    [(StationsDataSource *)self.tableView.dataSource setIsSearching:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Station *station = [(StationsDataSource *)self.tableView.dataSource stationForIndexPath:indexPath];
#warning Playing!
/*    if (station != model.currentStation) {
        if (Player.isPlaying) [Player pause];
        model.currentStation = station;
        [Player play];
        self.navigationItem.rightBarButtonItem = self.pauseButton;
    }*/
    
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
#warning Favourites
    /*
    if (![Favourites isFavourite:model.currentStation.identifier])
        [Favourites addToFavourites:model.currentStation.identifier];
    else
        [Favourites removeFavourite:model.currentStation.identifier];
    
    [Favourites saveFavourites];
     */
    
#warning Reloading data
//    [model loadData];
        
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
   
#warning A to to nie wiem
//    self.navigationItem.leftBarButtonItem = [self barButtonForStation:model.currentStation];
}

- (IBAction)action:(id)sender {
#warning To też nie wiem
    /*
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
     */
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
#warning I to tak samo
    /*
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
     */
}

@end
