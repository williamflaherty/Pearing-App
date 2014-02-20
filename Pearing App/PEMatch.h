//
//  PEMatch.h
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEUser.h"
#import "PEImage.h"

@interface PEMatch : NSObject

@property (nonatomic) PEUser *user;
@property (nonatomic) PEImage *profileImage;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic) NSArray *images;

@end
