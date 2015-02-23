//
//  PEService.m
//  Pearing
//
//  Created by Nathan Ziebart on 2/22/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import "PEUserService.h"

static NSString *const UserTokenKey = @"PEUserService_UserToken";

@implementation PEUserService {
    PearingClient *_apiClient;
    PEStorage *_storage;
}

- (id)initWithAPIClient:(PearingClient *)client storage:(PEStorage *)storage {
    self = [super init];
    
    _apiClient = client;
    _storage = storage;
    
    return self;
}

- (BOOL)isUserLoggedIn {
    return self.userToken != nil;
}

- (NSString *)userToken {
    return [_storage objectForKey:UserTokenKey];
}

@end
