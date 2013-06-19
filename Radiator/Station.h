//
//  Station.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *artworkName;

+ (Station *)stationWithDictionary:(NSDictionary *)dictionary;
- (NSString *) identifier;
- (BOOL) compare:(Station *)theOtherOne;
- (NSString *) comparableName;

@end