//
//  DetailViewController.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "DetailViewController.h"
#import "Favourites.h"
#import "Player.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize artwork;
@synthesize heartButton;
@synthesize nameLabel;
@synthesize pictogramView;
@synthesize playButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureElements];
}


- (void) configureElements{
    NSString *loveString = @"";
    [artwork setImage:[UIImage imageNamed:[currentStation objectForKey:@"artworkName"]]];
    [heartButton setSelected:[Favourites isFavourite:[currentStation objectForKey:@"name"]]];
    [playButton setSelected:[Player isPlaying]];
    [nameLabel setText:[currentStation objectForKey:@"name"]];
    if (heartButton.selected) loveString = @"Love";
    [pictogramView setImage:[UIImage imageNamed:[[[currentStation objectForKey:@"category"] stringByAppendingString:loveString] stringByAppendingString:@"High"]]];
}

- (void)viewDidUnload
{
    [self setArtwork:nil];
    [self setHeartButton:nil];
    [self setNameLabel:nil];
    [self setPictogramView:nil];
    [self setPlayButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissMe:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)changeLove:(id)sender {
    if ([Favourites isFavourite:[currentStation objectForKey:@"name"]] )
        [Favourites removeFavourite:[currentStation objectForKey:@"name"]];
    else
        [Favourites addToFavourites:[currentStation objectForKey:@"name"]];
    
    [self configureElements];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loveHurtsNotification" object:nil];
}

- (IBAction)playPause:(id)sender {
    if ([Player isPlaying]) {
        [Player pause];
    }
    else{
        [Player play];
    }
    [self configureElements];
}

- (void)dealloc {
    [artwork release];
    [heartButton release];
    [nameLabel release];
    [pictogramView release];
    [playButton release];
    [super dealloc];
}
@end
