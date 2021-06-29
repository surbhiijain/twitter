//
//  ComposeViewController.m
//  twitter
//
//  Created by Surbhi Jain on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () 
@property (weak, nonatomic) IBOutlet UITextView *tweetContentView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetContentView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tweetContentView.layer.borderWidth = 1.0;
    self.tweetContentView.layer.cornerRadius = 8;
    
    self.profilePicView.layer.cornerRadius  = self.profilePicView.frame.size.width/2;

    // Do any additional setup after loading the view.
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
            [self dismissViewControllerAnimated:true completion:nil];
            [self.delegate didTweet:tweet];
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
