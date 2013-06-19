//
//  AppDelegate.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "AppDelegate.h"
#import "Favourites.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Favourites loadFavourites];
    
    _player = [[AVPlayer alloc] init];
    
    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:nil];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    return YES;
}

- (void) remoteControlReceivedWithEvent:(UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (Player.isPlaying)   [Player pause];
                else                    [Player play];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                //[self previousTrack: nil];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                //[self nextTrack: nil];
                break;
            default:
                break;
        }
    }
}

@end
