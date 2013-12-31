//
//  LoginViewController.m
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/22/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    
	// Do any additional setup after loading the view.
}

-(IBAction)igLogin:(id)sender
{
//        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    _webView.delegate = self;
//    _webView.hidden = YES;
//    _webView.suppressesIncrementalRendering = 1;
//    [_webView loadRequest:reqObj];
    //maybe think about starting a loading animation/image set here....
    //[self.view addSubview:_webView];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //webView.hidden = NO;
    //....and ending the loading animation here.
   // [UIView animateWithDuration:.5 animations:^{
    //    webView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
   // }];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
