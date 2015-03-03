//
//  PEService.m
//  Pearing
//
//  Created by Nathan Ziebart on 2/22/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import "PEUserService.h"
#import "PEUser.h"

static NSString *const UserTokenKey = @"PEUserService_UserToken";
static NSString *const UserInfoKey = @"PEService_UserInfo";

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

-(PEUser *)userInfo {
    
    NSDictionary *dict = [_storage objectForKey:UserInfoKey];
    if (!dict) return nil;
    
    return [[PEUser alloc] initWithDictionary:dict error:nil];
    
}

-(PEUser *)updateUserInfo:(PEUser *)updates{
    
    PEUser *updatedUser = [_apiClient  updateUser:updates];
    
    if(updatedUser){
        [_storage setObject:[updatedUser toDictionary] forKey:UserInfoKey];
    }
    
    return updatedUser;
}

-(void)saveUser:(PEUser *)person withCompletion:(void (^)(PEUser *, NSError *))completion {
    
    [_apiClient registerUser:person withCompletion:^(PEUser *retPerson, NSError *error) {
        //do stuff
        if(retPerson){
            [_storage setObject:[retPerson toDictionary] forKey:UserInfoKey];
            completion(retPerson, nil);
        }
        else {
            completion(nil, error);
        }
        
        
    }];
    
}


@end
