//
//  PEUser.h
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

typedef enum PEUserGender: int {
    Female = 0,
    Male = 1
} PEGender;

typedef enum PEUserOrientation: int {
    Heterosexual = 1,
    Homosexual = 2
} PEOrientation;

@interface PEUser : JSONModel

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *handle;
//@property (nonatomic) NSArray  *imageURLs;
@property (nonatomic) NSString *birthday;
@property (nonatomic) NSString *tagline;
@property (nonatomic) int age;
@property (nonatomic) PEGender gender;
@property (nonatomic) int age_start;
@property (nonatomic) int age_end;
@property (nonatomic) PEOrientation orientation;
@property (nonatomic) NSString *token;

-(instancetype) initWithHandle:(NSString*)handle
                   andUserName:(NSString*)username
                     andGender:(int)gender
                        andAge:(int)age
                   andBirthday:(NSString *)birthday
     andDescriptionAndBullshit:(NSString*)desc;

@end
