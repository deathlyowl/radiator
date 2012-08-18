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
    [delegate.player play];
}

+ (void) pause {
    [delegate.player pause];
}

+ (void) setStation:(NSDictionary *) station{
    [self pause];
    
    currentStation = station;
    
    delegate.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:[station objectForKey:@"URL"]]];
    
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:[station objectForKey:@"artworkName"]]];
    
    NSArray *keys = [NSArray arrayWithObjects:MPMediaItemPropertyAlbumTitle, MPMediaItemPropertyArtist, MPMediaItemPropertyArtwork, MPMediaItemPropertyTitle, nil];
    NSArray *values = [NSArray arrayWithObjects:@"", @"", albumArt, [station objectForKey:@"name"], nil];
    NSDictionary *mediaInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaInfo];

}

+ (BOOL) isPlaying{
    return delegate.player.rate != 0.;
}

@end
