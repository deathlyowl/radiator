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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
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
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
        /*
        for (int i=0; i <= [wordsInSentence count]; ++i) {
            UIImageView *imageView1 = [[[UIImageView alloc] initWithFrame:CGRectMake(30+90*(i%4), 15, 80, 100)] autorelease] ;
            imageView1.tag = i+1;
            
            [imageViewArray insertObject:imageView1 atIndex:i];
            [cell.contentView addSubview:imageView1];
        }
         */
        
    }
    
    [cell.imageView setImage:[UIImage imageNamed:@"tokfm"]];
    [cell.textLabel setText:@"Tokfm"];
    [cell.detailTextLabel setText:@"opis, czy coś"];
    
    /*
    int photosInRow;
    
    if ( (indexPath.row < [tableView numberOfRowsInSection:indexPath.section] - 1) || ([wordsInSentence count] % 4 == 0) ) {
        photosInRow = 4;
    } else {
        photosInRow = [wordsInSentence count] % 4;
    }
    
    for ( int i = 1; i <=photosInRow ; i++ ){
        imageView = (UIImageView *)[cell.contentView viewWithTag:j];
        [self showImage:imageView];
    }
    */
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

@end
