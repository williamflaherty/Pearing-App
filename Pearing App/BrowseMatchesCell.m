//
//  BrowseMatchesCell.m
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import "BrowseMatchesCell.h"
#import "NZImageCache.h"

@interface BrowseMatchesCell ()

- (IBAction)chatAndChallenge:(id)sender;
- (IBAction)toggleFavorite:(id)sender;

@end

@implementation BrowseMatchesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)matchImagesScrollView:(id)scrollView didSelectImage:(PEImage *)image {
    [self.delegate cell:self didSelectImage:image];
}

- (void)chatAndChallenge:(id)sender {
    [self.delegate cellDidReqestChatAndChallenge:self];
}

- (void)toggleFavorite:(id)sender {
    self.favoriteButton.selected = !self.favoriteButton.selected;
    [self.delegate cellDidToggleFavorite:self];
}

- (void)setMatch:(PEMatch *)match {
    _match = match;
    
    self.userNameLabel.text = match.user.userName;
    self.descriptionLabel.text = match.user.description;
    [self.profileImageView setImageUrl:match.profileImage.thumbnailURL cache:[NZImageCache instance]];
    
    self.imagesScrollView.images = match.images;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
