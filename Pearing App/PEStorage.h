//
//  PEStorage.h
//  Pearing
//
//  Created by Nathan Ziebart on 2/22/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEStorage : NSObject

- (void) setObject:(id)object forKey:(NSString *)key;
- (id) objectForKey:(NSString *)key;

@end
