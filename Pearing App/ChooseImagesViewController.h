//
//  ChooseImagesViewController.h
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/23/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface ChooseImagesViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property(strong, nonatomic) NSMutableArray *instagramPictures;
@property(strong, nonatomic) NSMutableDictionary *userImages;
@property(strong, nonatomic) IBOutlet UINavigationItem *navBar;
@property(strong, nonatomic) NSMutableArray *selectedPictures;


@end
