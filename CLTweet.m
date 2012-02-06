//
//  Tweet.m
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTweet.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEndpoints.h"
#import "CLTwitterEngine.h"
#import "GTMHTTPFetcher.h"
#import "NSDictionary+UrlEncoding.h"
#import "CLTWeetMedia.h"

@implementation CLTweet

#pragma mark Properties

- (NSString *)text
{
    return [_dictionary objectForKey:@"text"];
}

- (NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    return [formatter dateFromString:[_dictionary objectForKey:CLTWITTER_TWEET_TIMESTAMP]];
}

- (NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    return [formatter stringFromDate:[formatter dateFromString:[_dictionary objectForKey:CLTWITTER_TWEET_TIMESTAMP]]];
}

- (CLTwitterUser *)user
{
    return [[CLTwitterUser alloc] initWithDictionary:[_dictionary objectForKey:CLTWITTER_TWEET_USER]];
}

- (void)setText:(NSString *)text
{
    [_dictionary setValue:text forKey:CLTWITTER_TWEET_BODY];
}

- (BOOL)isReply
{
    return [_dictionary objectForKey:CLTWITTER_TWEET_IN_REPLY_TO_ID] != [NSNull null];
}

- (NSNumber *)tweetId
{
    return [_dictionary objectForKey:CLTWITTER_TWEET_ID];
}

- (CLTweetMedia *)media
{
    if (_media == nil)
    {
        _media = [[CLTweetMedia alloc] initWithParentText:[self text] mediaData:[_dictionary objectForKey:CLTWITTER_TWEET_MEDIA]];
    }
    
    return _media;
}

- (NSString *)expandedText
{
    return [[self media] textWithURLsExpanded];
}

- (BOOL)isRetweet
{
    return [_dictionary objectForKey:CLTWITTER_TWEET_RETWEETED_TWEET] != nil;
}

- (CLTweet *)retweetedTweet
{
    if (_retweetedTweet == nil)
    {
        if ([self isRetweet])
        {
            _retweetedTweet = [[CLTweet alloc] initWithDictionary:[_dictionary objectForKey:CLTWITTER_TWEET_RETWEETED_TWEET]];
        }
    }
    
    return _retweetedTweet;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithJSONData:(NSData *)data
{
    if (self = [super init])
    {
        _dictionary = [[CLTwitterEngine sharedEngine] convertJSON:data];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _dictionary = dictionary;
    }
    
    return self;
}

#pragma mark -
#pragma mark Instance Methods

- (void)getTweetRepliedToWithCompletionHandler:(CLTweetHandler)handler
{
    if ([self isReply])
    {
        [CLTweet getTweetWithId:[_dictionary objectForKey:CLTWITTER_TWEET_IN_REPLY_TO_ID] completionHandler:handler];
    }
    else
    {
        handler(nil, nil);
    }
}

- (void)deleteTweetWithCLErrorHandler:(CLErrorHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_DELETE_TWEET_ENDPOINT_FORMAT, [self tweetId]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:url]];
    [[fetcher mutableRequest] setHTTPMethod:@"POST"];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        handler(error);
    }];
}

#pragma mark -
#pragma mark Class Methods

+ (void)getTweetWithId:(NSNumber *)tweetId completionHandler:(CLTweetHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:[NSString stringWithFormat:CLTWITTER_GET_TWEET_BY_ID_ENDPOINT_FORMAT, tweetId]]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error != nil)
        {
            handler(nil, error);
        }
        else
        {
            CLTweet *tweet = [[CLTweet alloc] initWithJSONData:data];
            handler(tweet, error);
        }
    }];
}

+ (void)postTweet:(NSString *)text completionHandler:(CLTweetHandler)handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CLTWITTER_POST_TWEET_ENDPOINT]]; 
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; 
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[[NSDictionary dictionaryWithObjectsAndKeys:text, CLTWITTER_TWEET_UPDATE_STATUS, nil] urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error == nil)
        {
            CLTweet *tweet = [[CLTweet alloc] initWithJSONData:data];
            handler(tweet, error);
        }
        else
        {
            handler(nil, error);
        }
    }];
}

@end