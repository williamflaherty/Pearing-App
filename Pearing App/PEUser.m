//
//  PEUser.m
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import "PEUser.h"
#import "PEStorage.h"
#import "PEInstagramService.h"
#import "PEContainer.h"

@implementation PEUser{
    PEInstagramService *_instagramService;
}

-(instancetype) initWithHandle:(NSString*)handle
                   andUserName:(NSString*)username
                     andGender:(int)gender
                        andAge:(int)age
                   andBirthday:(NSString *)birthday
     andDescriptionAndBullshit:(NSString*)desc{
    
    _instagramService = [PEContainer instagramService];
    
    PEStorage *pearingStorage = [[PEStorage alloc ]init];
    int orientationRand = (1 + arc4random_uniform(2)); //these values are numbers in the db gens 1 or 2
    //int userRand = (1 + arc4random_uniform(5000)); //generating random user names atm
    //NSString *userRandString = [NSString stringWithFormat:@"CoolPerson%d", userRand];
    
    //save some of this info to user defaults, this should probably be it's own function
    //for each one or for a set of them to update the info, probably should make use of the
    //pearing user class nathan made
    PEUser *person = [[PEUser alloc] init];
    person.username = handle; //userRandString; //WF: this is temporary so the database has unique usernames
    person.handle = handle;
    person.birthday = birthday;
    person.tagline = desc;
    person.age = age;
    person.gender = gender;
    person.age_start = age-2;
    person.age_end = age+3;
    person.orientation = orientationRand;
    person.token = [pearingStorage objectForKey:@"PEInstagramService_AccessToken"]; //we have to have the access token not sure what the best route is for this.
    
    return person;
    
}


@end
