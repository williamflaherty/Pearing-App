//
//  PearingClient.m
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import "PearingClient.h"

@implementation PearingClient

+ (instancetype)instance {
    static PearingClient *client;
    if (!client) {
        client = [PearingClient new];
    }
    return client;
}

- (void)createNewUserWithName:(NSString *)userName gender:(PEGender)gender age:(int)age description:(NSString *)description images:(NSArray *)images completion:(void (^)(BOOL, NSString *))completionHandler {
    
    completionHandler(YES, nil);
}

- (void) getMatchesWithCompletion:(void (^)(NSArray *, NSString *))completionHandler {
    NSString *sampleImageURL = @"http://crdm.chass.ncsu.edu/sites/public/files/nisbet-profile.jpg";
    PEImage *sampleImage = [PEImage imageWithFullSizeURL:sampleImageURL thumbnailURL:sampleImageURL];
    NSArray *sampleImages = @[sampleImage,sampleImage,sampleImage,sampleImage,sampleImage];
    
    PEUser *sampleUser = [PEUser new];
    sampleUser.userName = @"macbeth";
    sampleUser.description = @"I was written by William Shakespeare.";
    
    PEMatch *sampleMatch = [PEMatch new];
    sampleMatch.profileImage = sampleImage;
    sampleMatch.images = sampleImages;
    sampleMatch.user = sampleUser;
    
    completionHandler(@[sampleMatch, sampleMatch], nil);
}

@end
