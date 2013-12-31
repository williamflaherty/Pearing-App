//
//  ViewController.m
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/22/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//#ifndef DEMO_MODE
    //if user isn't authenticated take them to the login screen, otherwise this is the first responder
    /*  if (![[PTLocalPatient localPatient] isAuthenticated]) {
     UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
     [self presentViewController:loginVC animated:NO completion:nil];
     }*/
    
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self presentViewController:loginVC animated:NO completion:nil];

//#endif
   // [self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
