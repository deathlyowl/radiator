//
//  RootViewController.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
    isSearching = NO;
    [super viewDidLoad];
    // Scroll off the searchbar
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    isSearching = (BOOL) searchString.length;
    NSLog(@"SS[%i]: %@", isSearching, searchString);
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching) switch (section) {
        case 0: return 0;
        case 1: return 0;
        case 2: return stations.count;
    }
    else switch (section) {
        case 0: return 2;
        case 1: return 0;
        case 2: return stations.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *station = [stations objectAtIndex:indexPath.row];

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[station objectForKey:@"category"]
                                                            forIndexPath:indexPath];
    
    [cell.textLabel setText:[station objectForKey:@"name"]];
    [cell.detailTextLabel setText:[station objectForKey:@"description"]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0: if(1 == 0) return nil; else return @"Ulubione";
        case 1: if(0 == 0) return nil; else return @"W okolicy";
        case 2: if(stations.count == 0) return nil; else return @"Wszystkie";
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *station = [stations objectAtIndex:indexPath.row];
    if (station != currentStation) {
        [Player setStation:station];
        [Player play];
    }
    else if (![Player isPlaying]) [Player play];
    
    
    self.navigationItem.rightBarButtonItem = self.pauseButton;
    self.navigationItem.leftBarButtonItem = self.heartButton;
    
    [self.navigationItem setTitle:[station objectForKey:@"name"]];
    
    [self.tableView deselectRowAtIndexPath:indexPath
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)dealloc {
    [_pauseButton release];
    [_playButton release];
    [_heartButton release];
    [super dealloc];
}
@end
