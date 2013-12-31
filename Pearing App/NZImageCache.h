//
//  NZImageCache.h
//  Pearing App
//
//  Created by Nathan Ziebart on 12/30/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IImageCache.h"

@interface NZImageCache : NSObject <IImageCache>

+ (instancetype) instance;

@end
