//
//  ViewController.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"
#import "Favourites.h"

#define REFRESH_HEADER_HEIGHT 110

@interface ListViewController ()

@end

@implementation ListViewController
@synthesize toolbar;
@synthesize tableView;
@synthesize searchBar;
@synthesize nowPlayingButton;
@synthesize nowPlayingBackground;
@synthesize heartButton;
@synthesize bottomFrame;
@synthesize blackView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Lovely mode
    lovelyMode = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loveHurts)
                                                 name:@"loveHurtsNotification"
                                               object:nil];
    
    // Copying locations to localLocations
    localStations = [NSArray arrayWithArray:stations];
    lovelyStations = [[NSArray alloc] init];
        
    [self refreshLove];
    
    playingIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nowPlaying"]];
    [playingIndicator setHighlightedImage:[UIImage imageNamed:@"nowPlayingHighlighted"]];
    [playingIndicator setFrame:CGRectMake(287., 0., 33., 66.)];
    
    // This little for is for hacking the KeyboardAppearance and
    // SearchBarBackground.
    for(UIView *subview in searchBar.subviews){
        if([subview isKindOfClass: [UITextField class]]) [(UITextField *)subview setKeyboardAppearance: UIKeyboardAppearanceAlert];
        if([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) [subview setAlpha:0.0F];
    }
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    // Trimming leading and trailing whitespaces and another shit about looong
    // spaces
    NSString *realSearchText = [[searchText stringByReplacingOccurrencesOfString:@" +" withString:@" "
                                                                         options:NSRegularExpressionSearch
                                                                           range:NSMakeRange(0, searchText.length)] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    // Copy of array for search
    NSMutableArray *searchArray = [NSMutableArray arrayWithArray:stations];
    
    // Index of elements to hide by search
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    
    // Exploding (trimmed and cleaned) search formula to words
    NSArray *words = [realSearchText componentsSeparatedByString:@" "];
    
    // Helping flag and helper
    BOOL passed;
    int factor;
    
    // Search algorithm!
    if([realSearchText length]) {                                               // if search forula occurs
        for (NSDictionary *item in searchArray) {                               // for all elements in array
            factor = words.count;                                               // count words in formula
            for (NSString *word in words) {                                     // and for every word in formula
                passed = NO;                                                    // initialize flag as negative
                if ([[item objectForKey:@"name"] rangeOfString:word options:NSCaseInsensitiveSearch].length || [[item objectForKey:@"description"] rangeOfString:word options:NSCaseInsensitiveSearch].length)
                    passed = YES;                                               // and if a word is in a range of elements NAME set flag as positive
                if (passed) factor--;                                           // if, after word, a flag is positive, decrease word counter by one
            }
            if (factor) [indexSet addIndex:[searchArray indexOfObject:item]];   // and if, after search formula, couter is NOT decreased to 0, save elements index
        }
    }
    
    // After searching, removing all elements from saved set
    [searchArray removeObjectsAtIndexes:indexSet];
    
    // Change pointer to list, with converting searchArray to unmutable array
    localStations = searchArray;
    
    // Sorting table by distance (sort is lost cause of static characteristic)
    // of locations array
    [self sortTable];
    
    // Reloading table
    [self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    // Hide keyboard after clicking searchButton
    [searchBar resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setTableView:nil];
    [self setSearchBar:nil];
    [self setNowPlayingButton:nil];
    [self setHeartButton:nil];
    [self setBottomFrame:nil];
    [self setBlackView:nil];
    [self setNowPlayingBackground:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [nowPlayingButton setEnabled:currentStation != nil];
    [self sortTable];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Usable shit
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    // Enabling shake gesture, part I.
    [self becomeFirstResponder];
}

-(BOOL)canBecomeFirstResponder {
    // Enabling shake gesture, part II.
    
    return YES;
}

- (void) sortTable{    
    //localStations = [localStations sortedArrayUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],nil]];
    
    localStations = [localStations sortedArrayUsingComparator:^(id a, id b) {
        NSString *first = [a objectForKey:@"name"];
        NSString *second = [b objectForKey:@"name"];
        if ([[[first componentsSeparatedByString:@" "] objectAtIndex:0] isEqual:@"Radio"])
            first = [first substringFromIndex:6];
        if ([[[second componentsSeparatedByString:@" "] objectAtIndex:0] isEqual:@"Radio"])
            second = [second substringFromIndex:6];
        return [first compare:second];}
                      ];
    
    [localStations retain];
    
    [self refreshLove];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    // When device is shaked, view changes to map.
    if (event.type == UIEventSubtypeMotionShake) [self showCurrentlyPlayingCell];
}

#pragma mark -
#pragma mark Table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (lovelyMode) return lovelyStations.count;
    else            return localStations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSDictionary *station;
    
    if (lovelyMode) station = [lovelyStations objectAtIndex:indexPath.row];
    else            station = [localStations objectAtIndex:indexPath.row];
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 65, 320, 1)];
        [separator setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.7]];
        [backgroundView addSubview:separator];
        [cell setBackgroundView:backgroundView];
    }
    
    NSString *loveString = @"";
    if ([Favourites isFavourite:[station objectForKey:@"name"]]) loveString = @"Love";
    
    [cell.imageView setImage:[UIImage imageNamed:[[station objectForKey:@"category"] stringByAppendingString:loveString]]];
    [cell.textLabel setText:[station objectForKey:@"name"]];
    [cell.detailTextLabel setText:[station objectForKey:@"description"]];
    
    [cell.imageView setHighlightedImage:[UIImage imageNamed:[[[station objectForKey:@"category"] stringByAppendingString:loveString] stringByAppendingString:@"High"]]];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectedCell"]];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithWhite:.28 alpha:1.]];
    [selectedBackgroundView addSubview:image];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    
    for (UIView *subview in cell.subviews)
        if (subview == playingIndicator) [playingIndicator removeFromSuperview];
    if (station == currentStation) [cell addSubview:playingIndicator];
    
    
    return cell;
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    // Instagram-header-toolbar-magic
    if (self.tableView.contentOffset.y < -44)       [toolbar setFrame:CGRectMake(0, 0, 320, 44)];
    else                                            [toolbar setFrame:CGRectMake(0, -self.tableView.contentOffset.y-44, 320, 44)];
    
    if (self.tableView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
        heartButton.selected = !lovelyMode;
    else
        if (!loveMe)
            heartButton.selected = lovelyMode;
    
    // Black end
    
    
    if (self.tableView.contentSize.height >= 460) {
        if (self.tableView.contentOffset.y+460. > self.tableView.contentSize.height) {
            [bottomFrame setFrame:CGRectMake(0, 416-(self.tableView.contentOffset.y+460. - self.tableView.contentSize.height), 320, 44)];
            [tableView setScrollIndicatorInsets:UIEdgeInsetsMake(44., 0, 4.+(self.tableView.contentOffset.y+460. - self.tableView.contentSize.height), 0)];
            [blackView setFrame:CGRectMake(0, 460 - (self.tableView.contentOffset.y+460. - self.tableView.contentSize.height), 320, 460)];
        }
        else{
            [bottomFrame setFrame:CGRectMake(0, 416, 320, 44)];
            [tableView setScrollIndicatorInsets:UIEdgeInsetsMake(44., 0, 4., 0)];
            [blackView setFrame:CGRectMake(0, 460, 320, 460)];
        }
    }
    else{
        if (self.tableView.contentOffset.y > -44) {
            [nowPlayingButton setFrame:CGRectMake(276., 0-self.tableView.contentOffset.y-44, 44, 44)];
            [nowPlayingBackground setFrame:CGRectMake(276., 0-self.tableView.contentOffset.y-44, 44, 44)];
            [bottomFrame setFrame:CGRectMake(0, 416-self.tableView.contentOffset.y-44, 320, 44)];
            [blackView setFrame:CGRectMake(0, 460-self.tableView.contentOffset.y-44, 320, 460)];
        }
        else{
            [nowPlayingButton setFrame:CGRectMake(276., 0, 44, 44)];
            [nowPlayingBackground setFrame:CGRectMake(276., 0, 44, 44)];
            [bottomFrame setFrame:CGRectMake(0, 416, 320, 44)];
            [blackView setFrame:CGRectMake(0, 460, 320, 460)];
        }
    }
    
    [searchBar resignFirstResponder];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT){
        loveMe = YES;
        [self performSelector:@selector(makeLove) withObject:nil afterDelay:0.];
    }
}

- (IBAction)makeLove {
    // Make sure
    loveMe = NO;
    
    // Lovely switch <3
    lovelyMode = heartButton.selected = !lovelyMode;
    
    // Row animations!
    [tableView beginUpdates];
    if (lovelyMode) [tableView deleteRowsAtIndexPaths:differences withRowAnimation:UITableViewRowAnimationFade];
    else            [tableView insertRowsAtIndexPaths:differences withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
    
    //[self showCurrentlyPlayingCell];
    
}

- (void) showCurrentlyPlayingCell{
    // Scroll to playing station
    if (currentStation) {
        int counter = -1;
        if (lovelyMode) {
            for (int i=0; i<lovelyStations.count; i++) if ([[lovelyStations objectAtIndex:i] isEqual:currentStation]) {
                counter = i;
                break;
            }
        } else{
            for (int i=0; i<localStations.count; i++) if ([[localStations objectAtIndex:i] isEqual:currentStation]) {
                counter = i;
                break;
            }
        }
        if (counter != -1) [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:counter inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *station;
    
    BOOL goThere = NO;
    
    if (lovelyMode) station = [lovelyStations objectAtIndex:indexPath.row];
    else            station = [localStations objectAtIndex:indexPath.row];
    
    goThere = station == currentStation;
    
    [localStations retain];
    [lovelyStations retain];
    
    
    if (station != currentStation) {
        [Player setStation:station];
        [Player play];
    }
    else if (![Player isPlaying]) [Player play];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [nowPlayingButton setEnabled:currentStation != nil];
    
    if (goThere) [self goToDetailView:nil];
}

- (IBAction)goToDetailView:(id)sender{
    DetailViewController *detailView = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [detailView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:detailView animated:YES];    
}


- (void) refreshLove{
    // Changes to animate
    differences = [[NSMutableArray alloc] init];
    
    // Beloved
    lovelyStations = [[NSArray alloc] init];
    for (int i=0; i<localStations.count; i++) {
        if ([Favourites isFavourite:[[localStations objectAtIndex:i] objectForKey:@"name"]]){
            lovelyStations = [lovelyStations arrayByAddingObject:[localStations objectAtIndex:i]];
        }
        else [differences addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [lovelyStations retain];
    [localStations retain];
}

// Reparing showed list
- (void) loveHurts{
    if (lovelyMode) {
        for (int i=0; i<lovelyStations.count; i++) {
            if (![Favourites isFavourite:[[lovelyStations objectAtIndex:i] objectForKey:@"name"]]){
                [tableView beginUpdates];
                
                // Its the shortest way.
                // Really.
                NSMutableArray *someweirdThing = [NSMutableArray arrayWithArray:lovelyStations];
                [someweirdThing removeObjectAtIndex:i];
                lovelyStations = [NSArray arrayWithArray:someweirdThing];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [tableView endUpdates];
            }
        }
    }
}

- (void)dealloc {
    [toolbar release];
    [tableView release];
    [searchBar release];
    [nowPlayingButton release];
    [heartButton release];
    [bottomFrame release];
    [blackView release];
    [nowPlayingBackground release];
    [super dealloc];
}
@end
