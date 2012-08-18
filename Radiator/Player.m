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
    if (self.isPlaying) [self pause];
    
    currentStation = station;
    delegate.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:[station objectForKey:@"URL"]]];
    
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:[station objectForKey:@"artworkName"]]];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"", MPMediaItemPropertyAlbumTitle, @"", MPMediaItemPropertyArtist, artwork, MPMediaItemPropertyArtwork, [station objectForKey:@"name"], MPMediaItemPropertyTitle, nil]];
}

+ (BOOL) isPlaying{
    return delegate.player.rate != 0.;
}

@end
