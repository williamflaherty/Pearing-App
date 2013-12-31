//
//  ChooseImagesCell.h
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/23/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingImageView.h"

@interface ChooseImagesCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet LoadingImageView *instagramPicture;
@property (nonatomic) IBOutlet UIImageView *screenView;

@end
