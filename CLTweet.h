//
//  Tweet.h
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTwitterUser.h"

@class CLTweet;
@class CLTweetMedia;

typedef void(^CLErrorHandler)(NSError *error);
typedef void(^CLTweetHandler)(CLTweet *tweet, NSError *error);

@interface CLTweet : NSObject
{
    NSDictionary *_dictionary;
    CLTweetMedia *_media;
    CLTweet *_retweetedTweet;
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
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)getTweetRepliedToWithCompletionHandler:(CLTweetHandler)handler;
- (void)deleteTweetWithCLErrorHandler:(CLErrorHandler)handler;
+ (void)getTweetWithId:(NSNumber *)tweetId completionHandler:(CLTweetHandler)handler;
+ (void)postTweet:(NSString *)text completionHandler:(CLTweetHandler)handler;
+ (void)postTweet:(NSString *)text withImage:(NSImage *)image completionHandler:(CLTweetHandler)handler;

@end
