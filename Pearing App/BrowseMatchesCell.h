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
#import "PearingClient.h"

@protocol BrowseMatchesCellDelegate

- (void) cellDidReqestChatAndChallenge:(id)cell;
- (void) cellDidToggleFavorite:(id)cell;
- (void) cell:(id)cell didSelectImage:(PEImage *)image;

@end

@interface BrowseMatchesCell : UITableViewCell <MatchImagesScrollViewDelegate>

@property (nonatomic) id<BrowseMatchesCellDelegate> delegate;

@property (nonatomic) PEMatch *match;

@property (nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (nonatomic) IBOutlet LoadingImageView *profileImageView;
@property (nonatomic) IBOutlet MatchImagesScrollView *imagesScrollView;
@property (nonatomic) IBOutlet UIButton *favoriteButton;
@property (nonatomic) IBOutlet UIButton *chatAndChallengeButton;
@property (strong, nonatomic) IBOutlet UIImageView *profileCard;
@property (nonatomic) PearingClient *pearingClient;

@property (nonatomic) UIEdgeInsets edgeInsets;

@end
