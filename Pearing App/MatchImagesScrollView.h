//
//  MatchImagesScrollView.h
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEImage.h"

@protocol MatchImagesScrollViewDelegate <NSObject>

- (void) matchImagesScrollView:(id)scrollView didSelectImage:(PEImage *)image;

@end



@interface MatchImagesScrollView : UIScrollView

@property (nonatomic) IBOutlet id<MatchImagesScrollViewDelegate> pearingDelegate;

@property (nonatomic) NSArray *images;
@property (nonatomic) float imageSpacing;
@property (nonatomic) float verticalPadding;

@end
