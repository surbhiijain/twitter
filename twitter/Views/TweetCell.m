//
//  TweetCell.m
//  twitter
//
//  Created by Surbhi Jain on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // make profile pictures circular
    self.profilePicView.layer.cornerRadius  = self.profilePicView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(UIButton *)sender {
    if (self.tweet.favorited) {
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self refreshData];
            }
        }];
    } else {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                [self refreshData];
            }
        }];
    }
}

- (IBAction)didTapRetweet:(UIButton *)sender {
    if (self.tweet.retweeted) {
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                [self refreshData];
            }
        }];
    } else {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self refreshData];
            }
        }];
    }
}

// update all labels and images in the cell
- (void)refreshData {
    
    self.profilePicView.image = nil;
    self.favoriteButton.imageView.image = nil;
    self.retweetButton.imageView.image = nil;
    
    self.NameLabel.text = self.tweet.user.name;
    self.usernameLabel.text = self.tweet.user.screenName;
    self.dateLabel.text = self.tweet.shortenedDate;
    self.tweetLabel.text = self.tweet.text;
    
    self.favoriteCountLabel.text =  [@(self.tweet.favoriteCount) stringValue];
    self.retweetCountLabel.text = [@(self.tweet.retweetCount) stringValue];
    self.replyCountLabel.text = [@(self.tweet.replyCount) stringValue];
    
    UIImage *favIcon = [UIImage imageNamed:@"favor-icon"];
    UIImage *favIconSelected = [UIImage imageNamed:@"favor-icon-red"];
    
    if (self.tweet.favorited) {
        self.favoriteButton.imageView.image = favIconSelected;
    } else {
        self.favoriteButton.imageView.image = favIcon;
    }
    
    UIImage *retweetIcon = [UIImage imageNamed:@"retweet-icon"];
    UIImage *retweetIconSelected = [UIImage imageNamed:@"retweet-icon-green"];
    
    if (self.tweet.retweeted) {
        self.retweetButton.imageView.image = retweetIconSelected;
    } else {
        self.retweetButton.imageView.image = retweetIcon;
    }
    
    NSString *profileURLString = self.tweet.user.profilePicture;
    NSURL *profileUrl = [NSURL URLWithString:profileURLString];
    [self.profilePicView setImageWithURL:profileUrl];
}

@end
