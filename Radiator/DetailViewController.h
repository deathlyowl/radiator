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

- (IBAction)dismissMe:(id)sender;
- (IBAction)changeLove:(id)sender;

@end
