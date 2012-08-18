//
//  DetailViewController.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "DetailViewController.h"
#import "Favourites.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize artwork;
@synthesize heartButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [artwork setImage:[UIImage imageNamed:[currentStation objectForKey:@"artworkName"]]];
    [heartButton setSelected:[Favourites isFavourite:[currentStation objectForKey:@"name"]]];
}

- (void)viewDidUnload
{
    [self setArtwork:nil];
    [self setHeartButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissMe:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)changeLove:(id)sender {
    if ([Favourites isFavourite:[currentStation objectForKey:@"name"]] )
        [Favourites removeFavourite:[currentStation objectForKey:@"name"]];
    else
        [Favourites addToFavourites:[currentStation objectForKey:@"name"]];
    
    [heartButton setSelected:[Favourites isFavourite:[currentStation objectForKey:@"name"]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loveHurtsNotification" object:nil];
}

- (void)dealloc {
    [artwork release];
    [heartButton release];
    [super dealloc];
}
@end
