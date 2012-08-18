//
//  DetailViewController.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *artwork;
@property (retain, nonatomic) IBOutlet UIButton *heartButton;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *pictogramView;
@property (retain, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)dismissMe:(id)sender;
- (IBAction)changeLove:(id)sender;
- (IBAction)playPause:(id)sender;

- (void) configureElements;

@end
