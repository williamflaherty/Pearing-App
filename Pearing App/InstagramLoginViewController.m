//
//  InstagramLoginViewController.m
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/23/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "InstagramLoginViewController.h"
#import "PearingAuth.h"

@interface InstagramLoginViewController ()

@end

@implementation InstagramLoginViewController

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
    self.webView.delegate = self;
    NSString *fullURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token",AUTHURL, CLIENTID, REDIRECT_URI];
    NSURL *loginURL = [NSURL URLWithString:fullURL];
    NSURLRequest *reqObj = [NSURLRequest requestWithURL:loginURL];
    //create operation queue to handle an async request so we don't block the main thread
    //while loading the website
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:reqObj queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
         if ([data length] > 0 && error == nil) [self.webView loadRequest:reqObj];
         else if (error != nil) NSLog(@"Error: %@", error); //should probably actually handle this
         }];
     }];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    //NSLog(@"URL STRING : %@ ",urlString);
    NSArray *urlParts = [urlString componentsSeparatedByString:[NSString stringWithFormat:@"%@/", REDIRECT_URI]];
    if ([urlParts count] > 1)
    {
        urlString = [urlParts objectAtIndex:1];
        NSRange accessToken = [urlString rangeOfString:@"#access_token="];
        //check to make sure the user granted access
        if (accessToken.location != NSNotFound) {
            NSString* strAccessToken = [urlString substringFromIndex: NSMaxRange(accessToken)];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            // Save access token to user defaults for later use.
            [defaults setObject:strAccessToken forKey:ACCESS_TOKEN];
            //parse the users ID out of the access token and store it in user ID
            NSArray *parts = [strAccessToken componentsSeparatedByString:@"."];
            NSString *userId = [parts objectAtIndex:0];
            [defaults setObject:userId forKey:USER_ID];
            NSLog(@"AccessToken = %@ ",strAccessToken);
            NSLog(@"UserID = %@ ", userId);
            [self transitionToProfile];
            return NO;
        }
        //if the user didn't grant access just dismiss the modal view controller
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

-(void)transitionToProfile
{
    //transition to the logged in/get started screen
    [self performSegueWithIdentifier:@"GetStarted" sender:nil];
//    UIViewController *loggedIn = [self.storyboard instantiateViewControllerWithIdentifier:@"GetStarted"];
//    [self.navigationController pushViewController:loggedIn animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
