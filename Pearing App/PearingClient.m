//
//  PearingClient.m
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

//#import "PEConfiguration.h" for some reason when I include this file I get multiple definition erros and I just didn't feel like trying to figure out why. If we do figure it out we can just replace the string down there with the actual API call.
#import "PearingClient.h"
#import "PearingAuth.h"
#import "PEContainer.h"
#import "PEStorage.h"

@implementation PearingClient {
    NSString *_serverURL;
}

- (instancetype)initWithServerUrl:(NSString *)serverUrl {
    self = [super init];
    
    _serverURL = serverUrl;

    return self;
}

- (NSOperationQueue *) operationQueue {
    static NSOperationQueue *queue = nil;
    if (!queue) {
        queue = [NSOperationQueue new];
    }
    return queue;
}

-(void) registerUser:(PEUser *)userInfo withCompletion:(void (^)(PEUser *, NSError *))completion {
    
    NSData *jsonData = [self convertObjectToNSData:[userInfo toDictionary]];
    //NSLog(@"JSON String: \n %@", [userInfo toJSONString]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8000/dateme_app/register_person/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(error){
            //should probably actually handle this gracefully
            NSLog(@"Error updating user:%@", error);
        }
        else {
            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"%@", dictData[@"data"][@"person"]);
            completion([[PEUser alloc] initWithDictionary:dictData[@"data"][@"person"] error:nil], nil);
        }
        
    }];
    
   // return [jsonArray objectAtIndex:0];
}

- (PEUser *) updateUser:(PEUser *)userInfo {
    
    __block NSMutableArray *jsonArray;
    NSData *jsonData = [self convertObjectToNSData:[userInfo toDictionary]];
    NSLog(@"JSON String: \n %@", [userInfo toJSONString]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8000/dateme_app/update_person/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(!error){
            //temporarily keeping to see if this works
            NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            jsonArray = [PEUser arrayOfModelsFromData:data error:&error];
            if(error){
                NSLog(@"Error converting updated user json to array:%@", error);
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                NSLog(@"\n\nPerson Dict from update user:\n");
                for (id key in jsonDict) {
                    NSLog(@"key: %@, value: %@ \n", key, [jsonDict objectForKey:key]);
                }
                
            }];
        }
        else {
            NSLog(@"Error updating user:%@", error);
        }
        
    }];
    
    return [jsonArray objectAtIndex:0];
    
}

-(NSData *) convertObjectToNSData:(NSDictionary*)obj {

    NSDictionary *jsonDictionary = @{
                                     @"app" : @{
                                                @"key":  @"qahLbKqZG79E4N9XJV9nfdsj"
                                                },
                                     @"person": obj
                                    };
    NSError * err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&err];
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    return jsonData;
    
}

- (void) getMatchesWithCompletion:(void (^)(NSArray *, NSString *))completionHandler {
    
    NSString *sampleImageURL = @"http://crdm.chass.ncsu.edu/sites/public/files/nisbet-profile.jpg";
    PEImage *sampleImage = [PEImage imageWithFullSizeURL:sampleImageURL thumbnailURL:sampleImageURL];
    NSArray *sampleImages = @[sampleImage,sampleImage,sampleImage,sampleImage,sampleImage];
    
    PEUser *sampleUser = [PEUser new];
    sampleUser.username = @"123456789012345678901234567890";
    sampleUser.tagline = @"aaaaakkkdkdkdkkdkdkdkdkdkkdkdkdkdkdkdkkdkdkdkdkkdkdkdkjfkdjfkdjfkdjfkjasdlkfja;sldjfa;iosjdf;aisjdf;ajsd;fijasd;lfkjasijfa;sidjf;iaemsc;iams";
    
    PEMatch *sampleMatch = [PEMatch new];
    sampleMatch.profileImage = sampleImage;
    sampleMatch.images = sampleImages;
    sampleMatch.user = sampleUser;
    
    completionHandler(@[sampleMatch, sampleMatch, sampleMatch, sampleMatch, sampleMatch], nil);
}


@end
