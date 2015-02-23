//
//  PEContainer.h
//  Pearing
//
//  Created by Nathan Ziebart on 2/22/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PearingClient.h"
#import "PEStorage.h"
#import "PEInstagramService.h"
#import "NZImageCache.h"


@interface PEContainer : NSObject

+ (PearingClient *) APIClient;

+ (PEStorage *) storage;

+ (PEInstagramService *) instagramService;

+ (id<IImageCache>) imageCache;

@end
