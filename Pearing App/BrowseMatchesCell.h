//
//  BrowseMatchesCell.h
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEMatch.h"
#import "MatchImagesScrollView.h"
#import "LoadingImageView.h"

@protocol BrowseMatchesCellDelegate

- (void) cellDidReqestChatAndChallenge:(id)cell;
- (void) cellDidToggleFavorite:(id)cell;
- (void) cell:(id)cell didSelectImage:(PEImage *)image;

@end

@interface BrowseMatchesCell : UITableViewCell <MatchImagesScrollViewDelegate>

@property (nonatomic) id<BrowseMatchesCellDelegate> delegate;

@property (nonatomic) PEMatch *match;

@property (nonatomic) IBOutlet UILabel *descriptionLabel, *userNameLabel;
@property (nonatomic) IBOutlet LoadingImageView *profileImageView;
@property (nonatomic) IBOutlet MatchImagesScrollView *imagesScrollView;
@property (nonatomic) IBOutlet UIButton *favoriteButton, *chatAndChallengeButton;

@property (nonatomic) UIEdgeInsets edgeInsets;

@end
