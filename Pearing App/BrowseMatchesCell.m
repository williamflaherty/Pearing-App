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
    UIColor *orangeColor = [UIColor colorWithRed:239/255.0f green:121/255.0f blue:103/255.0f alpha:1.0f];
    //setup profile picture
    //this is currently using the default users profile picture
    //when we load matches it will be from the match lollll
    self.profilePicture.layer.cornerRadius = (self.profilePicture.frame.size.height)/2;
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.borderWidth = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *picUrl = [defaults URLForKey:@"profilePictureURL"];
    self.profilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL: picUrl]];
    
    //setup the chats and challenges button
    [[self.chatAndChallengeButton layer] setBorderWidth:.5f];
    [[self.chatAndChallengeButton layer] setBorderColor:[orangeColor CGColor]];
    [[self.chatAndChallengeButton layer] setCornerRadius:5.0f];
    [[self.chatAndChallengeButton layer] setMasksToBounds:YES];
    [self.chatAndChallengeButton setTitleColor:orangeColor forState:UIControlStateNormal];
    
    //setup the favorites button
    [[self.favoriteButton layer] setBorderWidth:.5f];
    [[self.favoriteButton layer] setBorderColor:[orangeColor CGColor]];
    [[self.favoriteButton layer] setCornerRadius:5.0f];
    [[self.favoriteButton layer] setMasksToBounds:YES];
    [self.favoriteButton setTitleColor:orangeColor forState:UIControlStateNormal];
    
    UIImage *image = [UIImage imageNamed:@"profileCard.png"];
    [self.profileCard setImage:image];
    self.userNameLabel.text = match.user.userName;
    self.descriptionLabel.text = match.user.desc;
    [self.profileImageView setImageUrl:match.profileImage.thumbnailURL cache:[NZImageCache instance]];
    
    self.imagesScrollView.images = match.images;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
