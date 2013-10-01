//
//  StationsDataSource.h
//  Radiator
//
//  Created by Paweł Ksieniewicz on 26.08.2013.
//  Copyright (c) 2013 Deathly Owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface StationsDataSource : NSObject <UITableViewDataSource> {
    Model *model;
}

@property (nonatomic) BOOL isSearching;

- (Station *) stationForIndexPath:(NSIndexPath *)indexPath;

@end