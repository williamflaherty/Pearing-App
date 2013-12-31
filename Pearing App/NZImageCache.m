//
//  NZImageCache.m
//  Pearing App
//
//  Created by Nathan Ziebart on 12/30/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "NZImageCache.h"

@implementation NZImageCache {
    NSCache *_cache;
}

+ (id) instance {
    static NZImageCache *cache = nil;
    if (!cache) {
        cache = [NZImageCache new];
    }
    return cache;
}

- (id)init {
    self = [super init];
    _cache = [NSCache new];
    return self;
}

- (void)saveImage:(UIImage *)image key:(NSString *)key {
    [_cache setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key {
    return [_cache objectForKey:key];
}

- (BOOL)hasImageForKey:(NSString *)key {
    return [self imageForKey:key] != nil;
}

@end
