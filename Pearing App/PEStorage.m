//
//  PEStorage.m
//  Pearing
//
//  Created by Nathan Ziebart on 2/22/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import "PEStorage.h"

@implementation PEStorage {
    NSUserDefaults *_userDefaults;
}

- (instancetype)init {
    self = [super init];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    return self;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    id value = [self removeNulls:object];
    
    if (value) {
        [_userDefaults setObject:value forKey:key];
    } else {
        [_userDefaults removeObjectForKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    return [_userDefaults objectForKey:key];
}

- (id) removeNulls:(id)object
{
    if ([object isKindOfClass:[NSNull class]]) {
        NSLog(@"NSNull detected in PEStorage");
        return nil;
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *copy = [NSMutableDictionary new];
        
        for(NSString *key in [object allKeys]) {
            id value = [self removeNulls:[object objectForKey:key]];
            if (value) {
                copy[key] = value;
            }
        }
        
        return copy;
    }
    
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *copy = [NSMutableArray new];
        
        for (id item in object) {
            [copy addObject:[self removeNulls:item]];
        }
        
        return copy;
    }
    
    return object;
}

@end
