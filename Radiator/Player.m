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

+ (void) setStation:(Station *) station{
    if (self.isPlaying) [self pause];
    
    [[Model sharedModel] setCurrentStation:station];
    
    delegate.player = [[AVPlayer alloc] initWithURL:station.URL];
    /*
    UIImage *image = [UIImage imageNamed:[station objectForKey:@"artworkName"]];
    if (image) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"", MPMediaItemPropertyAlbumTitle, @"", MPMediaItemPropertyArtist, artwork, MPMediaItemPropertyArtwork, [station objectForKey:@"name"], MPMediaItemPropertyTitle, nil]];
    }
    else{
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"", MPMediaItemPropertyAlbumTitle, @"", MPMediaItemPropertyArtist, [station objectForKey:@"name"], MPMediaItemPropertyTitle, nil]];
    }
     */
}

+ (BOOL) isPlaying{
    return delegate.player.rate != 0.;
}

@end
