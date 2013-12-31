//
//  InstagramLoginViewController.h
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/23/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface InstagramLoginViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
