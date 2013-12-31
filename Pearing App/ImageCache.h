//
//  ImageCache.h
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/24/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

@property (nonatomic, retain) NSCache *imageCache;

#pragma mark - Methods
+(ImageCache*)sharedImageCache;
-(void)AddImage:(NSString *)imageUrl :(UIImage *)image;
-(UIImage*)GetImage:(NSString *)imageUrl;
-(BOOL)DoesExist:(NSString *)imageUrl;

@end
