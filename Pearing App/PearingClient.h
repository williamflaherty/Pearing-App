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
// images should contain UIImages
- (void) createNewUserWithHandle:(NSString *)handle
                          gender:(PEGender)gender
                             age:(int)age
                     description:(NSString *)description
                      completion:(void (^)(BOOL success, NSString *error))completionHandler;

- (PEUser *) registerUser:(PEUser *)userInfo;
- (PEUser *) updateUser:(PEUser *)userInfo;

// Gets the current list of matches for the specified user
// returned array contains PEMatches
- (void) getMatchesWithCompletion:(void (^)(NSArray *matches, NSString *error))completionHandler;



@end
