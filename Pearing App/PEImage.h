//
//  PEImage.h
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEImage : NSObject

@property (nonatomic) NSString *fullSizeURL, *thumbnailURL;

+ (PEImage *) imageWithFullSizeURL:(NSString *)url thumbnailURL:(NSString *)thumbURL;

@end
