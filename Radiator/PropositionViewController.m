//
//  PropositionViewController.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 23.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import "PropositionViewController.h"

@interface PropositionViewController ()

@end

@implementation PropositionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_nameField becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    [_descriptionField becomeFirstResponder];
}
@end
