//
//  Player.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "Player.h"
#import "AppDelegate.h"

@implementation Player

+ (AVPlayer *) player { return [(AppDelegate *)[[UIApplication sharedApplication] delegate] player]; }
+ (void) play { [[Player player] play]; }
+ (void) pause { [[Player player] pause]; }

+ (BOOL) isPlaying{ return [Player player].rate != 0.; }

+ (void) setStation:(Station *) station{
    if (self.isPlaying) [self pause];
    [[Model sharedModel] setCurrentStation:station];
}

@end