//
//  GetStartedViewController.m
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/23/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "GetStartedViewController.h"

@interface GetStartedViewController ()

@end

@implementation GetStartedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get the users profile picture and username
    NSDictionary *userInfo = [self getUserInfo];
    userInfo = [userInfo objectForKey:@"data"];
    NSString *strPicUrl = [userInfo objectForKey:@"profile_picture"];
    //NSLog(@"pic url= %@ ", strPicUrl);
   // NSString *strPicUrl = [NSString stringWithFormat:[userInfo objectForKey:@"profile_picture"]];
    NSURL *picUrl = [NSURL URLWithString:strPicUrl];
    //save the profile picture URL for later use in NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Save access token to user defaults for later use.
    [defaults setURL:picUrl forKey:@"profilePictureURL"];
    UIImage *pp = [UIImage imageWithData:[NSData dataWithContentsOfURL: picUrl]];
    self.profilePicture.layer.cornerRadius = (self.profilePicture.frame.size.height)/2;
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.borderWidth = 0;
    self.profilePicture.image = pp;
    self.helloUserName.text = [NSString stringWithFormat:@"Hello, %@", [userInfo objectForKey:@"username"]];
    [defaults setValue:[userInfo objectForKey:@"username"] forKey:@"userName"];
    
    //save the bio into the user defaults for later
    [defaults setValue:[userInfo objectForKey:@"bio"] forKey:@"userBio"];
    
   // NSLog(@"%@", userInfo);
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (IBAction)getStartedPressed:(id)sender
{
    UIViewController *chooseImages = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseImages"];
    [self.navigationController pushViewController:chooseImages animated:YES];
}


//Should probably add some error checking to this method
-(NSDictionary *)getUserInfo
{
    NSString *url = [NSString stringWithFormat:@"%@%@?access_token=%@", APIURl, [[NSUserDefaults standardUserDefaults] valueForKey:USER_ID], [[NSUserDefaults standardUserDefaults] valueForKey:ACCESS_TOKEN]];

    //NSLog(@"%@", url);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    //NSLog(@"Response : %@",dictResponse);

    return dictResponse;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
