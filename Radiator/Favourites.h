//
//  Favourites.h
//  lokale
//
//  Created by Paweł Ksieniewicz on 02.06.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Favourites : NSObject

+ (void) loadFavourites;
+ (void) saveFavourites;
+ (void) removeFavourite:(NSString *) title;
+ (void) addToFavourites:(NSString *) title;
+ (BOOL) isFavourite:(NSString *) title;

@end
