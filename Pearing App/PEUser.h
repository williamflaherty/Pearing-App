//
//  PEUser.h
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PEUserGender: int {
    Female = 0,
    Male = 1
} PEGender;

@interface PEUser : NSObject

@property (nonatomic) NSString *userName;
@property (nonatomic) NSArray *imageURLs;
@property (nonatomic) NSString *description;
@property (nonatomic) int age;
@property (nonatomic) PEGender gender;

@end
