//
//  IImageCache.h
//  Pearing App
//
//  Created by Nathan Ziebart on 12/30/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IImageCache <NSObject>

- (void) saveImage:(UIImage *)image key:(NSString *)key;
- (UIImage *) imageForKey:(NSString *)key;
- (BOOL) hasImageForKey:(NSString *)key;

@end
