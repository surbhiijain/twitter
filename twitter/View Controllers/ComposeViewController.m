//
//  ComposeViewController.m
//  twitter
//
//  Created by Surbhi Jain on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController () 
@property (weak, nonatomic) IBOutlet UITextView *tweetContentView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserImage];
    
    self.tweetContentView.delegate = self;
    self.tweetContentView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tweetContentView.layer.borderWidth = 1.0;
    self.tweetContentView.layer.cornerRadius = 8;
    
    self.characterCountLabel.text = @"280";
    
    self.profilePicView.layer.cornerRadius  = self.profilePicView.frame.size.width/2;

    // Do any additional setup after loading the view.
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 280;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.tweetContentView.text stringByReplacingCharactersInRange:range withString:text];

    // TODO: Update character count label
    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) 280 - newText.length];
    if (newText.length == 280) {
        self.characterCountLabel.textColor = [UIColor redColor];
    } else {
        self.characterCountLabel.textColor = [UIColor blackColor];
    }

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
}

- (IBAction)didClose:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTweet:(UIBarButtonItem *)sender {
    NSString *tweetText = self.tweetContentView.text;
    [[APIManager shared] postStatusWithText:tweetText completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        } else{
            tweet.text = tweetText;
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (void)getUserImage {
    [[APIManager shared] getUserSettings:^(NSDictionary *userSettings, NSError *error) {
        if (userSettings) {
            NSString *screen_name = userSettings[@"screen_name"];
            [[APIManager shared] getProfilePic:screen_name completion:^(NSDictionary *user, NSError *error) {
                if (user) {
                    NSString *profileURLString = user[@"profile_image_url_https"];
                    NSURL *profileUrl = [NSURL URLWithString:profileURLString];
                    [self.profilePicView setImageWithURL:profileUrl];
                } else {
                    NSLog(@"Error getting profile picture: %@", error.localizedDescription);
                }
            }];

        } else {
            NSLog(@"Error getting user information: %@", error.localizedDescription);
        }
    }];
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
