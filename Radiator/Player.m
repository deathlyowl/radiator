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

+ (AVPlayer *) player{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] player];
}

+ (void) play {
    [[Player player] play];
}

+ (void) pause {
    [[Player player] pause];
}

+ (void) setStation:(Station *) station{
    if (self.isPlaying) [self pause];
    
    [[Model sharedModel] setCurrentStation:station];
    
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
    return [Player player].rate != 0.;
}

@end
