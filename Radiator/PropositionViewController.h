//
//  PropositionViewController.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 23.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropositionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionField;
- (IBAction)submit:(id)sender;
- (IBAction)next:(id)sender;

@end
