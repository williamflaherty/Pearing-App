//
//  LoadingImageView.m
//  Pearing App
//
//  Created by Nathan Ziebart on 12/30/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "LoadingImageView.h"

@implementation LoadingImageView {
    NSString *_imageUrl;
}

- (NSOperationQueue *) operationQueue {
    static NSOperationQueue *queue = nil;
    if (!queue) {
        queue = [NSOperationQueue new];
    }
    return queue;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (void) setup {
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_activityIndicator];
        _activityIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
}

- (void)setImageUrl:(NSString *)url cache:(id<IImageCache>)cache {
    _imageUrl = url;
    UIImage *image = [cache imageForKey:url];
    
    if (image) {
        self.image = image;
    } else {
        self.image = nil;
        [self loadImage:url cache:cache];
    }
}

- (void)loadImage:(NSString *)url cache:(id)cache {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.activityIndicator startAnimating];
    [NSURLConnection sendAsynchronousRequest:request queue:[self operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data.length && !error) {
            UIImage *image = [UIImage imageWithData:data];
            [cache saveImage:image key:url];
            
            // Need to update image on UI thread
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                
                // Only set this image if we haven't been asked to load a new image while the first one was still loading
                if ([url isEqualToString:_imageUrl]) {
                    self.image = image;
                    [self.activityIndicator stopAnimating];
                }
            }];
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.activityIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

@end
