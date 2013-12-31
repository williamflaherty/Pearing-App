//
//  LoadingImageView.h
//  Pearing App
//
//  Created by Nathan Ziebart on 12/30/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IImageCache.h"

@interface LoadingImageView : UIImageView

@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void) setImageUrl:(NSString *)url cache:(id<IImageCache>)cache;

@end
