//
//  PEService.h
//  Pearing
//
//  Created by Nathan Ziebart on 2/22/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PearingClient.h"
#import "PEStorage.h"

@interface PEUserService : NSObject

@property (nonatomic, readonly) BOOL isRegistered;

- (instancetype) initWithAPIClient:(PearingClient *)client
                           storage:(PEStorage *)storage;

- (BOOL) isUserLoggedIn;
- (NSString *) userToken;
- (PEUser *) userInfo;
- (void)saveUser:(PEUser *)person withCompletion:(void (^)(PEUser *, NSError *))completion;

@end
