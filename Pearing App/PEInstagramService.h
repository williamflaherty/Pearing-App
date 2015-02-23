//
//  PEInstagramService.h
//  Pearing
//
//  Created by Nathan Ziebart on 2/22/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEStorage.h"
#import "JSONModel.h"

@class PEInstagramUserInfo;

@interface PEInstagramService : NSObject

- (instancetype) initWithAuthURL:(NSString *)authURL
                          apiURL:(NSString *)apiURL
                        clientID:(NSString *)clientID
                    clientSecret:(NSString *)clientSecret
                     redirectURL:(NSString *)redirectURL
                         storage:(PEStorage *)storage;

// Returns whether or not the service has access to the user's Instagram account
- (BOOL) hasAccess;

// Returns cached user info, or nil if the user info has never been loaded
- (PEInstagramUserInfo *) userInfo;

// Gets a request that can be loaded into a UIWebView to request access to the user's account
- (NSURLRequest *) getAuthenticationRequest;

// Attempts to parse the Instagram redirect request.
// This should be called within the webView:shouldStartLoadWithRequest: handler
// Returns NO if the request is not an Instagram redirect request
- (BOOL) tryParseRedirectRequest:(NSURLRequest *)redirectRequest accessGranted:(BOOL *)accessGranted;

// Loads the user's Instagram account info
- (void) loadUserInfoWithCompletion:(void(^)(PEInstagramUserInfo *userInfo, NSError *error))completion;

// Loads the user's recent images
// Passing nil for pageToken will load the first page of images
// The returned nextPageToken can be used to access the next set of images
- (void) loadRecentImages:(NSString *)pageToken completion:(void(^)(NSArray *imageURLs, NSString *nextPageToken, NSError *error))completion;

@end

@interface PEInstagramUserInfo : JSONModel

- (instancetype) initWithInstagramDictionary:(NSDictionary *)dict;

@property (nonatomic) NSString *profilePictureURL;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *bio;

@end


