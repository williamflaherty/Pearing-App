//
//  PEContainer.m
//  Pearing
//
//  Created by Nathan Ziebart on 2/22/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import "PEContainer.h"
#import "PEConfiguration.h"
#import "PEUserService.h"

@implementation PEContainer

+ (PearingClient *)APIClient {
    static PearingClient *client;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[PearingClient alloc] initWithServerUrl:PEConfiguration_ServerURL];
    });
    
    return client;
}

+ (PEStorage *)storage {
    static PEStorage *storage;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storage = [[PEStorage alloc] init];
    });
    
    return storage;
}

+ (PEInstagramService *)instagramService {
    static PEInstagramService *service;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[PEInstagramService alloc]
                   initWithAuthURL:PEConfiguration_InstagramAuthURL
                   apiURL:PEConfiguration_InstagramAPIURL
                   clientID:PEConfiguration_InstagramClientID
                   clientSecret:PEConfiguration_InstagramClientSecret
                   redirectURL:PEConfiguration_InstagramRedirectURL
                   storage:[self storage]];
    });
    
    return service;
}

+ (PEUserService *)pearingService {
    static PEUserService *service;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[PEUserService alloc]
                   initWithAPIClient:[self APIClient]
                   storage:[self storage]
                   ];
    });
    
    return service;
}

+ (id<IImageCache>)imageCache {
    return [NZImageCache instance];
}

@end
