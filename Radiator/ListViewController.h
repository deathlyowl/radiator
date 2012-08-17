//
//  ViewController.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UIView *toolbar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@end
