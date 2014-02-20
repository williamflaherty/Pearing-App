//
//  PEImage.m
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import "PEImage.h"

@implementation PEImage


+ (PEImage *)imageWithFullSizeURL:(NSString *)url thumbnailURL:(NSString *)thumbURL {
    PEImage *image = [PEImage new];
    
    image.thumbnailURL = thumbURL;
    image.fullSizeURL = url;
    
    return image;
}


@end
