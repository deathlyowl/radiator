//
//  Model.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 18.06.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignalRangeModel.h"

@interface Model : NSObject{
    SignalRangeModel *model;
    NSDictionary *antennaDictionary;
}

@property (nonatomic, retain) NSArray *stations;
@property (nonatomic, retain) NSArray *filteredStations;
@property (nonatomic, retain) NSArray *favouriteStations;
@property (nonatomic, retain) NSArray *nearbyStations;
@property (nonatomic, retain) NSArray *filteredNearbyStations;
@property (nonatomic, retain) NSArray *filteredFavouriteStations;

@property (nonatomic, retain) NSSet *nearbySet;

@property (nonatomic, retain) Station *currentStation;

+ (Model *) sharedModel;
- (void) importStationsFromServer;
- (void) loadData;
- (void) filterWithString:(NSString *)string;

@end