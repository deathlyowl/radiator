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
@synthesize heartButton;

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

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setTableView:nil];
    [self setSearchBar:nil];
    [self setNowPlayingButton:nil];
    [self setHeartButton:nil];
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
    localStations = [localStations sortedArrayUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],nil]];
    
    [localStations retain];
    
    [self refreshLove];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    // When device is shaked, view changes to map.
    //if (event.type == UIEventSubtypeMotionShake) [self goToMap];
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
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithWhite:.28 alpha:1.]];
    [cell setSelectedBackgroundView:selectedBackgroundView];
        
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
    [super dealloc];
}
@end
