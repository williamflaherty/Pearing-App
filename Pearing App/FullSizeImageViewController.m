//
//  FullSizeImageViewController.m
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import "FullSizeImageViewController.h"
#import "NZImageCache.h"

@interface FullSizeImageViewController ()

- (IBAction)dismiss:(id)sender;

@end

@implementation FullSizeImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [self.imageView setImageUrl:imageURL cache:[NZImageCache new]];
}

- (void)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	 [self.imageView setImageUrl:self.imageURL cache:[NZImageCache new]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
