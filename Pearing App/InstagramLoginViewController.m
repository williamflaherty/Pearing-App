//
//  InstagramLoginViewController.m
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/23/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "InstagramLoginViewController.h"
#import "PEInstagramService.h"
#import "PEContainer.h"

@interface InstagramLoginViewController ()

@end

@implementation InstagramLoginViewController {
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
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    //font is flat-ui-pro-icons
    if (_instagramService == nil) {
        _instagramService = [PEContainer instagramService];
    }
    
    self.webView.delegate = self;
    
    NSURLRequest *authenticationRequest = [_instagramService getAuthenticationRequest];
    [self.webView loadRequest:authenticationRequest];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL permissionGranted;
    
    if ([_instagramService tryParseRedirectRequest:request accessGranted:&permissionGranted]) {
        // UIWebView will call didFailLoanWithError: when this method returns NO
        self.webView.delegate = nil;
        
        if (permissionGranted) {
            [self transitionToProfile];
        } else {
            // TODO: show alert message
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"WebView failed to load: %@", error);
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)transitionToProfile
{
    [self performSegueWithIdentifier:@"GetStarted" sender:nil];
}

@end
