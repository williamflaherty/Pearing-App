//
//  LoginViewController.h
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/22/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#define AUTHURL @"https://api.instagram.com/oauth/authorize/"
#define APIURl @"https://api.instagram.com/v1/users/"
#define CLIENTID @"8952eacd1f004b5688b6052e9b6cb3d0"
#define CLIENTSERCRET @"ed789713b6944db9b39356343e53216d"
#define REDIRECT_URI @"http://www.pearingapp.com"
#define ACCESS_TOKEN @"accessToken"
#define USER_ID @"userId"

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *instagramLogin;

@end
