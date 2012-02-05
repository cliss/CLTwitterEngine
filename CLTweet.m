//
//  Tweet.m
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTweet.h"
#import "CLTweetJSONStrings.h"
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
    return [formatter dateFromString:[_dictionary objectForKey:CLTWEET_TIMESTAMP]];
}

- (NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    return [formatter stringFromDate:[formatter dateFromString:[_dictionary objectForKey:CLTWEET_TIMESTAMP]]];
}

- (CLTwitterUser *)user
{
    return [[CLTwitterUser alloc] initWithDictionary:[_dictionary objectForKey:CLTWEET_USER]];
}

- (void)setText:(NSString *)text
{
    [_dictionary setValue:text forKey:CLTWEET_BODY];
}

- (BOOL)isReply
{
    return [_dictionary objectForKey:CLTWEET_IN_REPLY_TO_ID] != [NSNull null];
}

- (NSNumber *)tweetId
{
    return [_dictionary objectForKey:CLTWEET_ID];
}

- (CLTweetMedia *)media
{
    if (_media == nil)
    {
        _media = [[CLTweetMedia alloc] initWithParent:self data:[_dictionary objectForKey:CLTWEET_MEDIA]];
    }
    
    return _media;
}

- (NSString *)expandedText
{
    return [[self media] expandUrlsInParent];
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
        [CLTweet getTweetWithId:[_dictionary objectForKey:CLTWEET_IN_REPLY_TO_ID] completionHandler:handler];
    }
    else
    {
        handler(nil, nil);
    }
}

- (void)deleteTweetWithCLErrorHandler:(CLErrorHandler)handler
{
    NSString *url = [NSString stringWithFormat:@"http://api.twitter.com/1/statuses/destroy/%@.json", [self tweetId]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:url]];
    [[fetcher mutableRequest] setHTTPMethod:@"POST"];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        handler(error);
    }];
}

- (BOOL)isRetweet
{
    return [_dictionary objectForKey:CLTWEET_RETWEETED_TWEET] != nil;
}

- (CLTweet *)retweetedTweet
{
    if ([self isRetweet])
    {
        return [[CLTweet alloc] initWithDictionary:[_dictionary objectForKey:CLTWEET_RETWEETED_TWEET]];
    }
    else
    {
        return nil;
    }
}

#pragma mark -
#pragma mark Class Methods

+ (void)getTweetWithId:(NSNumber *)tweetId completionHandler:(CLTweetHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/show.json?id=%@&include_entities=true", tweetId]]];
    NSLog(@"%@", [[fetcher mutableRequest] URL]);
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]]; 
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; 
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[[NSDictionary dictionaryWithObjectsAndKeys:text, CLTWEET_UPDATE_STATUS, nil] urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    
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