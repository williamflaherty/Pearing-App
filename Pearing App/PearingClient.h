//
//  PearingClient.h
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEUser.h"
#import "PEMatch.h"

@interface PearingClient : NSObject



@property (nonatomic) NSString *localUserName;

- (instancetype) initWithServerUrl:(NSString *)serverUrl;

// Registers a new user
- (void) registerUser:(PEUser *)userInfo withCompletion:(void (^)(PEUser *, NSError *))completion;
- (PEUser *) updateUser:(PEUser *)userInfo;

// Gets the current list of matches for the specified user
// returned array contains PEMatches
- (void) getMatchesWithCompletion:(void (^)(NSArray *matches, NSString *error))completionHandler;



@end
