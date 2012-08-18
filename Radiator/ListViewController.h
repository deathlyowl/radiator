//
//  ViewController.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    // localStations is a stations copy, showed as list in main tableView, filtered by search
    // and sorted by name
    NSArray *localStations, *lovelyStations;
    NSMutableArray *differences;
    
    // Pull to heart
    BOOL lovelyMode, loveMe;
}

@property (retain, nonatomic) IBOutlet UIView *toolbar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIButton *nowPlayingButton;
@property (retain, nonatomic) IBOutlet UIButton *heartButton;

- (void) refreshLove;
- (void) sortTable;

@end
