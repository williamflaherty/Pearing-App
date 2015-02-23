//
//  PEInstagramService.m
//  Pearing
//
//  Created by Nathan Ziebart on 2/22/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import "PEInstagramService.h"

static NSString *const AccessTokenKey = @"PEInstagramService_AccessToken";
static NSString *const UserIDKey = @"PEInstagramService_UserID";
static NSString *const UserInfoKey = @"PEInstagramService_UserInfo";

@implementation PEInstagramService {
    NSString *_authURL;
    NSString *_apiURL;
    NSString *_clientID;
    NSString *_clientSecret;
    NSString *_redirectURL;
    PEStorage *_storage;
}

- (instancetype)initWithAuthURL:(NSString *)authURL
                         apiURL:(NSString *)apiURL
                       clientID:(NSString *)clientID
                   clientSecret:(NSString *)clientSecret
                    redirectURL:(NSString *)redirectURL
                        storage:(PEStorage *)storage{
    self = [super init];
    
    _authURL = authURL;
    _apiURL = apiURL;
    _clientID = clientID;
    _clientSecret = clientSecret;
    _redirectURL = redirectURL;
    
    _storage = storage;
    
    return self;
}

- (NSURLRequest *)getAuthenticationRequest {
    NSString *url = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token",_authURL, _clientID, _redirectURL];
    
    return [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
}

- (BOOL) tryParseRedirectRequest:(NSURLRequest *)request accessGranted:(BOOL *)accessGranted {
    NSString *url = request.URL.absoluteString;
    
    if ([self isRedirectURL:url]) {
        NSString *userID = nil;
        NSString *accessToken = [self parseAccessToken:url userID:&userID];
        
        if (accessToken && userID)
        {
            NSLog(@"Permission granted");
            
            [_storage setObject:accessToken forKey:AccessTokenKey];
            [_storage setObject:userID forKey:UserIDKey];
            
            *accessGranted = YES;
            return YES;
        }
        else
        {
            // If no access token is present, user did not grant access permission
            NSLog(@"User did not grant permission");
            
            *accessGranted = NO;
            return YES;
        }
    }
    
    *accessGranted = NO;
    return NO;
}

- (BOOL) isRedirectURL:(NSString *)url {
    return [url rangeOfString:[_redirectURL stringByAppendingString:@"/"]].location != NSNotFound;
}

- (NSString *)parseAccessToken:(NSString *)url userID:(NSString **)userID {
    NSRange accessTokenRange = [url rangeOfString:@"#access_token="];
    
    if (accessTokenRange.location != NSNotFound) {
        NSString *accessToken = [url substringFromIndex:NSMaxRange(accessTokenRange)];
        
        // The access token is in the form <user_id>.<other_stuff>
        *userID = [accessToken componentsSeparatedByString:@"."][0];
        
        return accessToken;
    }
    
    return nil;
}

- (void)loadUserInfoWithCompletion:(void (^)(PEInstagramUserInfo *, NSError *))completion {
    [self ensureHasAccess];
    
    NSString *url = [NSString stringWithFormat:@"%@%@?access_token=%@", _apiURL, [self userID], [self accessToken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error getting user info: %@", error);
            
            completion(nil, error);
            return;
        }
        
        @try
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            PEInstagramUserInfo *userInfo = [[PEInstagramUserInfo alloc] initWithInstagramDictionary:json[@"data"]];
            
            [_storage setObject:[userInfo toDictionary] forKey:UserInfoKey];
            
            completion(userInfo, nil);
        }
        @catch (NSException *exception)
        {
            NSLog(@"Error parsing user info: %@", exception);
            
            completion(nil, [NSError errorWithDomain:@"com.pearing" code:-1 userInfo:@{@"Message" : @"Unable to parse response"}]);
        }
    }];
}

- (void)loadRecentImages:(NSString *)pageToken completion:(void (^)(NSArray *, NSString *, NSError *))completion {
    NSString *url = pageToken;
    
    if (!url) {
        url = [NSString stringWithFormat:@"%@%@/media/recent?access_token=%@", _apiURL, [self userID], [self accessToken]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error loading images: %@", error);
            
            completion(nil,nil, error);
        }
        
        @try
        {
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSString *nextURL = json[@"pagination"][@"next_url"];
            NSArray *images = json[@"data"];
            
            completion(images, nextURL, nil);
        }
        @catch (NSException *exception)
        {
            NSLog(@"Error parsing response: %@", exception);
            
            completion(nil,nil, [NSError errorWithDomain:@"com.pearing" code:-1 userInfo:@{@"Exception" : exception}]);
        }
    }];
}

- (PEInstagramUserInfo *)userInfo {
    NSDictionary *dict = [_storage objectForKey:UserInfoKey];
    if (!dict) return nil;
    
    return [[PEInstagramUserInfo alloc] initWithDictionary:dict error:nil];
}

- (NSString *) userID {
    return [_storage objectForKey:UserIDKey];
}

- (NSString *) accessToken {
    return [_storage objectForKey:AccessTokenKey];
}

- (BOOL) hasAccess {
    return [self userID] && [self accessToken];
}

- (void) ensureHasAccess {
    if (![self hasAccess]) {
        [NSException raise:@"NoInstagramAccess" format:@"No access token exists for the current user"];
    }
}

@end

@implementation PEInstagramUserInfo

- (instancetype) initWithInstagramDictionary:(NSDictionary *)dict {
    self = [super init];
    
    self.profilePictureURL = dict[@"profile_picture"];
    self.username = dict[@"username"];
    self.bio = dict[@"bio"];
    
    return self;
}

@end
