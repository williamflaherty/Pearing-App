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


+ (instancetype) instance;

@property (nonatomic) NSString *localUserName;

// Registers a new user
// images should contain UIImages
- (void) createNewUserWithHandle:(NSString *)handle
                          gender:(PEGender)gender
                             age:(int)age
                     description:(NSString *)description
                      completion:(void (^)(BOOL success, NSString *error))completionHandler;

- (void) updateUserWithHandle:(NSString *)handle
                       gender:(int)gender
                     birthday:(NSString *)birthday
                  description:(NSString *)description
                     ageBegin:(NSString *)ageBegin
                       ageEnd:(NSString *)ageEnd
                  orientation:(int)orientation
                   completion:(void (^)(BOOL success, NSString *error))completionHandler;

- (void) updateUserDefaultsWithHandle:(NSString *)handle
                               gender:(int)gender
                             birthday:(NSString *)birthday
                          description:(NSString *)description
                             ageBegin:(NSString *)ageBegin
                               ageEnd:(NSString *)ageEnd
                          orientation:(int)orientation
                             distance:(NSString *)distance;

// Gets the current list of matches for the specified user
// returned array contains PEMatches
- (void) getMatchesWithCompletion:(void (^)(NSArray *matches, NSString *error))completionHandler;



@end
