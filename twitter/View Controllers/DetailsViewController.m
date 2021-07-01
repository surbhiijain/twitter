//
//  detailsViewController.m
//  twitter
//
//  Created by Surbhi Jain on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // make profile pictures circular
    self.profilePicView.layer.cornerRadius  = self.profilePicView.frame.size.width/2;
    [self refreshData];
}

- (void)refreshData {
    
    self.profilePicView.image = nil;
    self.favoriteButton.imageView.image = nil;
    self.retweetButton.imageView.image = nil;
    
    self.nameLabel.text = self.tweet.user.name;
    self.usernameLabel.text = self.tweet.user.screenName;
    self.dateLabel.text = self.tweet.fullDate;
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

- (IBAction)didTapRetweet:(UIButton *)sender {
    if (self.tweet.retweeted) {
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                [self.delegate didAction];
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
                [self.delegate didAction];
                [self refreshData];
            }
        }];
    }
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
                [self.delegate didAction];
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
                [self.delegate didAction];
                [self refreshData];
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
