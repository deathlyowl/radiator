//
//  AppDelegate.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreLocation/CoreLocation.h>
#import "Player.h"
#import "Model.h"

@class ListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioSessionDelegate>

@property (nonatomic, retain) AVPlayer *player;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ListViewController *viewController;

@end