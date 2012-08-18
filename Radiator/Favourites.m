//
//  Favourites.m
//  lokale
//
//  Created by Paweł Ksieniewicz on 02.06.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "Favourites.h"

@implementation Favourites

+ (void) loadFavourites{
    if (!favouritesSet) favouritesSet = [[[NSSet alloc] init] autorelease];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults)
        if ([standardUserDefaults objectForKey:@"favourites"]){
            favouritesSet = [[NSSet alloc] initWithSet:[NSKeyedUnarchiver unarchiveObjectWithData:[standardUserDefaults objectForKey:@"favourites"]]];
        }
}

+ (void) saveFavourites{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
        NSData *serializedSet = [NSKeyedArchiver archivedDataWithRootObject:favouritesSet];        
		[standardUserDefaults setObject:serializedSet forKey:@"favourites"];
		[standardUserDefaults synchronize];
	}
    if (favouritesSet.retainCount < 2) [favouritesSet retain];
}

+ (void) removeFavourite:(NSString *) title{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"! SELF like %@", title];
    favouritesSet = [favouritesSet filteredSetUsingPredicate:predicate];
    [self saveFavourites];
}

+ (void) addToFavourites:(NSString *) title{
    favouritesSet = [favouritesSet setByAddingObject:title];
    [self saveFavourites];
}

+ (BOOL) isFavourite:(NSString *) title{
    return [favouritesSet containsObject:title];
}

@end
