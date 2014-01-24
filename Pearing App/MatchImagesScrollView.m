//
//  MatchImagesScrollView.m
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import "MatchImagesScrollView.h"
#import "LoadingImageView.h"
#import "NZImageCache.h"

@implementation MatchImagesScrollView {
    NSMutableArray *_imageViews;
    NSMutableDictionary *_imageDict;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageSpacing = 5;
        _imageViews = @[].mutableCopy;
        _imageDict = @{}.mutableCopy;
        _verticalPadding = 5;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _imageSpacing = 5;
        _imageViews = @[].mutableCopy;
        _imageDict = @{}.mutableCopy;
        _verticalPadding = 5;
    }
    return self;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    
    [self clear];
    [self createImageViews];
    [self layoutImageViews];
}

- (void) createImageViews {
    for (PEImage *image in self.images) {
        LoadingImageView *imageView = [LoadingImageView new];
        [imageView setImageUrl:image.thumbnailURL cache:[NZImageCache new]];
        imageView.userInteractionEnabled = YES;
        [self configureAppearanceForImageView:imageView];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [imageView addGestureRecognizer:recognizer];
        _imageDict[@(recognizer.hash)] = image;
        
        [_imageViews addObject:imageView];
        [self addSubview:imageView];
    }
}

- (void) imageTapped:(id)sender {
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)sender;
    PEImage *image = _imageDict[@(recognizer.hash)];
    
    [self.pearingDelegate matchImagesScrollView:self didSelectImage:image];
}

- (void) layoutImageViews {
    int index = 0;
    float imageWidth = self.frame.size.height - self.verticalPadding * 2;
    
    for (UIImageView *imageView in _imageViews) {
        CGRect frame;
        
        frame.origin.x = (self.imageSpacing * (index+1)) + (imageWidth * index);
        frame.origin.y = self.verticalPadding;
        frame.size.width = imageWidth;
        frame.size.height = imageWidth;
        imageView.frame = frame;
        
        imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds].CGPath;
        
        index++;
    }
    
    float totalWidth = imageWidth * _imageViews.count + self.imageSpacing * (_imageViews.count+1);
    self.contentSize = CGSizeMake(totalWidth, self.bounds.size.height);
}

- (void) configureAppearanceForImageView:(UIImageView *)imageView {
    imageView.layer.shadowOpacity = 1.0;
    imageView.layer.shadowOffset = CGSizeMake(0,2);
    imageView.layer.shadowRadius = 2;
    imageView.backgroundColor = [UIColor blueColor];
}

- (void) clear {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [_imageViews removeAllObjects];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutImageViews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
