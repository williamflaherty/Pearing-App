//
//  PearingClient.m
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import "PearingClient.h"
#import "PearingAuth.h"

@implementation PearingClient

+ (instancetype)instance {
    static PearingClient *client;
    if (!client) {
        client = [PearingClient new];
    }
    return client;
}

- (NSOperationQueue *) operationQueue {
    static NSOperationQueue *queue = nil;
    if (!queue) {
        queue = [NSOperationQueue new];
    }
    return queue;
}

- (void)createNewUserWithName:(NSString *)userName gender:(PEGender)gender age:(int)age description:(NSString *)description completion:(void (^)(BOOL, NSString *))completionHandler {
    
    //save user to server
    NSURL *registerUserUrl = [NSURL URLWithString:@"http://127.0.0.1:8000/dateme_app/register_person/"];
    NSData *postData = [self jSonify:userName:gender:age:description];
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON String: \n %@", jsonString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            NSLog(@"Person Dict:\n");
            for (id key in jsonDict) {
                NSLog(@"key: %@, value: %@ \n", key, [jsonDict objectForKey:key]);
            }
            
        }];
    }];

    
    
    completionHandler(YES, nil);
    
}

- (NSData *)jSonify:(NSString *)handle :(PEGender)gender :(int)age :(NSString *)description{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int orientationRand = (1 + arc4random_uniform(2)); //these values are numbers in the db
    int userRand = (1 + arc4random_uniform(1000)); //generating random user names atm
    NSString *userRandString = [NSString stringWithFormat:@"CoolPerson%d", userRand];
    int genderNum = (gender == Female) ? 1 : 2;
    NSDictionary *appDict = [NSDictionary dictionaryWithObjectsAndKeys:SECRET_KEY, @"key", nil];
    NSDictionary *personDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                //[defaults objectForKey:@"userName"],@"username",
                                userRandString, @"username",
                                
                                [defaults objectForKey:ACCESS_TOKEN], @"token",
                                
                                handle, @"handle",
                                
                                @"1991-10-09", @"birthday",
                                
                                [NSString stringWithFormat:@"%d", age-2], @"age_start",
                                
                                [NSString stringWithFormat:@"%d", age+3], @"age_end",
                                
                                @(genderNum), @"gender",
                                
                                @(orientationRand), @"orientation",
                                
                                [NSString stringWithFormat:@"%d", age], @"age",
                                
                                description, @"tagline",
                                
                                nil];
    NSLog(@"Person Dict:\n");
    for (id key in personDict) {
        NSLog(@"key: %@, value: %@ \n", key, [personDict objectForKey:key]);
    }
    
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                appDict, @"app",
                                personDict, @"person",
                                nil];
    
    if ([NSJSONSerialization isValidJSONObject:postDict]) {
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error == nil && jsonData != nil) {
            return jsonData;
        } else {
            NSLog(@"Error creating JSON data: %@", error);
            return nil;
        }
        
    }
    
    else {
        
        NSLog(@"trackDictionary is not a valid JSON object.");
        return nil;
    }
    
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
