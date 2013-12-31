//
//  ImageCache.m
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/24/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

@synthesize imageCache;

#pragma mark - Methods

static ImageCache* sharedImageCache = nil;

+(ImageCache*)sharedImageCache
{
    @synchronized([ImageCache class])
    {
        if(!sharedImageCache) sharedImageCache = [[self alloc] init];
        return sharedImageCache;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([ImageCache class])
    {
        NSAssert(sharedImageCache == nil, @"Attempted to allocate a second instance of a singleton");
        sharedImageCache = [super alloc];
        return sharedImageCache;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        imageCache = [[NSCache alloc] init];
    }
    return self;
}

-(void)AddImage:(NSString *)imageUrl :(UIImage *)image
{
    if(image)
    {
        [imageCache setObject:image forKey:imageUrl];
    }
}

-(UIImage *)GetImage:(NSString *)imageUrl
{
    return [imageCache objectForKey:imageUrl];
}

-(BOOL)DoesExist:(NSString *)imageUrl
{
    if([imageCache objectForKey:imageUrl] == nil)
    {
        return FALSE;
    }
    return TRUE;
}

@end
