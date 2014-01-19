//
//  FullSizeImageViewController.h
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingImageView.h"

@interface FullSizeImageViewController : UIViewController

@property (nonatomic) NSString *imageURL;

@property (nonatomic) IBOutlet LoadingImageView *imageView;

@end
