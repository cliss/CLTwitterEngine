//
//  Tweet.h
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Ironworks Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTwitterUser.h"

@class CLTweet;
@class CLTweetMedia;

typedef void(^errorHandler)(NSError *error);
typedef void(^tweetHandler)(CLTweet *tweet, NSError *error);

@interface CLTweet : NSObject
{
    NSDictionary *_dictionary;
    CLTweetMedia *_media;
}

@property (readonly) NSNumber *tweetId;
@property (readonly) NSString *text;
@property (readonly) CLTwitterUser *user;
@property (readonly) NSDate *date;
@property (readonly) NSString *dateString;
@property (readonly) BOOL isReply;
@property (readonly) NSString *expandedText;
@property (readonly) CLTweetMedia *media;
@property (readonly) BOOL isRetweet;
@property (readonly) CLTweet *retweetedTweet;

- (id)initWithJSONData:(NSData *)data;
- (void)getTweetRepliedToWithCompletionHandler:(tweetHandler)handler;
- (void)deleteTweetWithErrorHandler:(errorHandler)handler;
+ (NSArray *)getTweetsFromJSONData:(NSData *)data;
+ (void)getTweetWithId:(NSNumber *)tweetId completionHandler:(tweetHandler)handler;
+ (void)postTweet:(NSString *)text completionHandler:(tweetHandler)handler;

@end
