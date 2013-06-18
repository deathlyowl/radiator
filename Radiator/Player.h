//
//  Player.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "Station.h"

@interface Player : NSObject

+ (void) play;
+ (void) pause;
+ (void) setStation:(Station *) station;
+ (BOOL) isPlaying;

@end

