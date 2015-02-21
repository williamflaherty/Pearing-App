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

- (void)createNewUserWithHandle:(NSString *)handle
                         gender:(PEGender)gender
                            age:(int)age
                    description:(NSString *)description
                     completion:(void (^)(BOOL, NSString *))completionHandler {
    
    //save user to server
    NSURL *registerUserUrl = [NSURL URLWithString:@"http://127.0.0.1:8000/dateme_app/register_person/"];
    NSData *postData = [self jSonifyHandle:handle gender:gender age:age andDescription:description];
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON String: \n %@", jsonString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
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
- (void) updateUserWithHandle:(NSString *)handle
                       gender:(int)gender
                     birthday:(NSString *)birthday
                  description:(NSString *)description
                     ageBegin:(NSString *)ageBegin
                       ageEnd:(NSString *)ageEnd
                  orientation:(int)orientation
                   completion:(void (^)(BOOL success, NSString *error))completionHandler{
    
}


- (void) updateUserDefaultsWithHandle:(NSString *)handle
                               gender:(int)gender
                             birthday:(NSString *)birthday
                          description:(NSString *)description
                             ageBegin:(NSString *)ageBegin
                               ageEnd:(NSString *)ageEnd
                          orientation:(int)orientation
                             distance:(NSString *)distance{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:handle forKey:@"handle"];
    //[defaults setObject:gender forKey:@"gender"];
    [defaults setObject:birthday forKey:@"birthday"];
    [defaults setObject:description forKey:@"userBio"];
    [defaults setObject:ageBegin forKey:@"ageBegin"];
    [defaults setObject:ageEnd forKey:@"ageEnd"];
    [defaults setObject:[NSNumber numberWithInt:orientation] forKey:@"orientation"];
    [defaults setObject:distance forKey:@"distance"];
    
}

- (NSData *)jSonifyHandle:(NSString *)handle
                   gender:(PEGender)gender
                   age:(int)age
        andDescription:(NSString *)description{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int orientationRand = (1 + arc4random_uniform(2)); //these values are numbers in the db
    int userRand = (1 + arc4random_uniform(5000)); //generating random user names atm
    NSString *userRandString = [NSString stringWithFormat:@"CoolPerson%d", userRand];
    int genderNum = (gender == Female) ? 1 : 2;
    
    //save some of this info to user defaults, this should probably be it's own function
    //for each one or for a set of them to update the info, probably should make use of the
    //pearing user class nathan made
    [defaults setObject:[NSNumber numberWithInt:age] forKey:@"age"];
    [defaults setObject:[NSNumber numberWithInt:(age-2)] forKey:@"ageBegin"];
    [defaults setObject:[NSNumber numberWithInt:(age+3)] forKey:@"ageEnd"];
    [defaults setObject:[NSNumber numberWithInt:genderNum] forKey:@"gender"];
    [defaults setObject:description forKey:@"userBio"];
    [defaults setObject:[NSNumber numberWithInt:orientationRand] forKey:@"orientation"];
    [defaults setObject:@"25" forKey:@"distance"];
    [defaults setObject:handle forKey:@"handle"];
    
    
    NSDictionary *appDict = [NSDictionary dictionaryWithObjectsAndKeys:SECRET_KEY, @"key", nil];
    NSDictionary *personDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                //[defaults objectForKey:@"userName"],@"username",
                                userRandString, @"username",
                                
                                [defaults objectForKey:ACCESS_TOKEN], @"token",
                                
                                handle, @"handle",
                                
                                [defaults objectForKey:@"Birthday"], @"birthday",
                                
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
    sampleUser.desc = @"I was written by William Shakespeare.";
    
    PEMatch *sampleMatch = [PEMatch new];
    sampleMatch.profileImage = sampleImage;
    sampleMatch.images = sampleImages;
    sampleMatch.user = sampleUser;
    
    completionHandler(@[sampleMatch, sampleMatch], nil);
}

@end
