//
//  GetStartedViewController.h
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/23/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingImageView.h"

@interface GetStartedViewController : UIViewController
@property (strong, nonatomic) IBOutlet LoadingImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UIButton *getStartedButton;
@property (strong, nonatomic) IBOutlet UILabel *helloUserName;

@end
