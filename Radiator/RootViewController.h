//
//  RootViewController.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Model.h"
#import "StationsDataSource.h"

@interface RootViewController : UITableViewController <UISearchDisplayDelegate, UIActionSheetDelegate, ADBannerViewDelegate>

@property (retain, nonatomic) IBOutlet UIBarButtonItem *pauseButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *heartButton;
- (IBAction)pause:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)love:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *titleButton;
- (IBAction)action:(id)sender;
@property (strong, nonatomic) IBOutlet ADBannerView *banner;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *unHeartButton;

@end