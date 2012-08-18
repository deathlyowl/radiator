//
//  ViewController.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController
@synthesize toolbar;
@synthesize tableView;
@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -
#pragma mark Table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return stations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSDictionary *station = [stations objectAtIndex:indexPath.row];
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
    }
    
    [cell.imageView setImage:[UIImage imageNamed:[station objectForKey:@"category"]]];
    [cell.textLabel setText:[station objectForKey:@"name"]];
    [cell.detailTextLabel setText:@"opis, czy coś"];

    return cell;
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    // Instagram-header-toolbar-magic
    if (self.tableView.contentOffset.y < -44)       [toolbar setFrame:CGRectMake(0, 0, 320, 44)];
    else                                            [toolbar setFrame:CGRectMake(0, -self.tableView.contentOffset.y-44, 320, 44)];
    [searchBar resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailView = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    NSDictionary *station = [stations objectAtIndex:indexPath.row];
    
    [detailView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    if (station != currentStation) {
        [Player setStation:station];
        [Player play];
    }
    else if (![Player isPlaying]) [Player play];
    
    [self presentModalViewController:detailView animated:YES];
}

- (void)dealloc {
    [toolbar release];
    [tableView release];
    [searchBar release];
    [super dealloc];
}
@end
