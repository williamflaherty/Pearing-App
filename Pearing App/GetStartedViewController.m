//
//  GetStartedViewController.m
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/23/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "GetStartedViewController.h"
#import "PearingAuth.h"
#import "PEContainer.h"

@interface GetStartedViewController ()

@end

@implementation GetStartedViewController {
    PEInstagramService *_instagramService;
}

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
    
    _instagramService = [PEContainer instagramService];
    
    [self loadUserInfo];
    
    self.profilePicture.layer.cornerRadius = (self.profilePicture.frame.size.height)/2;
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.borderWidth = 0;
}

- (void) loadUserInfo {
    [_instagramService loadUserInfoWithCompletion:^(PEInstagramUserInfo *info, NSError *error) {
        if (error) {
            // TODO: Show error alert
            return;
        }
        
        [self displayUserInfo:info];
    }];
}

- (void) displayUserInfo:(PEInstagramUserInfo *)info
{
    self.helloUserName.text = [NSString stringWithFormat:@"Hello, %@", info.username];
    
    [self.profilePicture setImageUrl:info.profilePictureURL cache:[PEContainer imageCache]];
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
