//
//  RootViewController.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UISearchDisplayDelegate>
@property (retain, nonatomic) IBOutlet UIBarButtonItem *pauseButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *heartButton;

@end
