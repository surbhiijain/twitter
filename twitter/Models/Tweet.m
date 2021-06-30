//
//  Tweet.m
//  twitter
//
//  Created by Surbhi Jain on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "DateTools.h"


@implementation Tweet

 - (instancetype)initWithDictionary:(NSDictionary *)dictionary {
     self = [super init];
     if (self) {

         // Is this a re-tweet?
         NSDictionary *originalTweet = dictionary[@"retweeted_status"];
         if(originalTweet != nil){
             NSDictionary *userDictionary = dictionary[@"user"];
             self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

             // Change tweet to original tweet
             dictionary = originalTweet;
         }
         self.idStr = dictionary[@"id_str"];
         self.text = dictionary[@"text"];
         self.favoriteCount = [dictionary[@"favorite_count"] intValue];
         self.favorited = [dictionary[@"favorited"] boolValue];
         self.retweetCount = [dictionary[@"retweet_count"] intValue];
         self.retweeted = [dictionary[@"retweeted"] boolValue];
         self.replyCount = [dictionary[@"reply_count"] intValue];
         
         // initialize user
         NSDictionary *user = dictionary[@"user"];
         self.user = [[[User alloc] initWithDictionary:user] init];
         
         // Format createdAt date string
         NSString *createdAtOriginalString = dictionary[@"created_at"];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
         NSDate *date = [formatter dateFromString:createdAtOriginalString];
         formatter.dateStyle = NSDateFormatterShortStyle;
         formatter.timeStyle = NSDateFormatterNoStyle;
         
         // use DateTools pod to add time ago feature
         NSDate *timeNow = [NSDate date];
         NSInteger seconds = [timeNow secondsFrom:date];
         NSDate *timeDate = [NSDate dateWithTimeIntervalSinceNow:-seconds];
         self.createdAtString = timeDate.shortTimeAgoSinceNow;

     }
     return self;
 }

// returns array of tweets when given an array of dictionaries
+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
