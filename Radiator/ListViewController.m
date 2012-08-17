//
//  ViewController.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "ListViewController.h"

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
}

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Player setStreamURL:@"http://mainstream.radioagora.pl/tuba10-1.mp3"];
    [Player play];
}

#pragma mark -
#pragma mark Table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
    }
    
    [cell.imageView setImage:[UIImage imageNamed:@"tokfm"]];
    [cell.textLabel setText:@"Tokfm"];
    [cell.detailTextLabel setText:@"opis, czy coś"];

    return cell;
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    // Instagram-header-toolbar-magic
    if (self.tableView.contentOffset.y < -44){
        [toolbar setFrame:CGRectMake(0, 0, 320, 44)];
    }
    else{
        [toolbar setFrame:CGRectMake(0, -self.tableView.contentOffset.y-44, 320, 44)];
    }
    [searchBar resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (void)dealloc {
    [toolbar release];
    [tableView release];
    [searchBar release];
    [super dealloc];
}
@end
