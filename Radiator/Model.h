//
//  Model.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, retain) NSArray *stations;
@property (nonatomic, retain) NSArray *favouriteStations;

+ (Model *) sharedModel;
- (void) importStationsFromServer;
- (void) fillSections;

@end
