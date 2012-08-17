//
//  Player.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "Player.h"

@implementation Player

+ (void) play {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.player play];
}

+ (void) pause {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.player pause];
}

+ (void) setStreamURL:(NSString *)url{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self pause];
    delegate.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:url]];
}

@end
