//
//  CLTwitterUser.m
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterUser.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEndpoints.h"
#import "GTMHTTPFetcher.h"
#import "CLTwitterEngine.h"

#define min(a,b) (((a) < (b)) ? (a) : (b))

@interface CLTwitterUser ()
- (id)initWithJSONData:(NSData *)data;
@end

@implementation CLTwitterUser

#pragma mark Properties

- (NSString *)name
{
    return [_dictionary valueForKey:CLTWITTER_USER_REAL_NAME];
}

- (NSString *)screenName
{
    return [_dictionary valueForKey:CLTWITTER_USER_SCREEN_NAME];
}

- (NSString *)nameOrScreenName
{
    return [self name] ? [self name] : [self screenName];
}

- (NSURL *)profileImageURL
{
    return [NSURL URLWithString:[_dictionary valueForKey:CLTWITTER_USER_PROFILE_IMAGE_URL]];
}

- (NSImage *)profileImage
{
    return [[NSImage alloc] initWithContentsOfURL:[self profileImageURL]];
}

- (BOOL)isVerified
{
    return [[_dictionary valueForKey:CLTWITTER_USER_PROFILE_IS_VERIFIED] boolValue];
}

- (NSString *)location
{
    return [_dictionary valueForKey:CLTWITTER_USER_LOCATION];
}

- (NSURL *)profileUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", [self screenName]]];
}

- (NSURL *)personalUrl
{
    id url = [_dictionary valueForKey:CLTWITTER_USER_PERSONAL_URL];
    return url != [NSNull null] ? [NSURL URLWithString:url] : nil;
}

- (NSNumber *)tweetCount
{
    return [_dictionary valueForKey:CLTWITTER_USER_TWEET_COUNT];
}

- (NSNumber *)listedCount
{
    return [_dictionary valueForKey:CLTWITTER_USER_LISTED_COUNT];
}

- (NSNumber *)followingCount
{
    return [_dictionary valueForKey:CLTWITTER_USER_FOLLWING_COUNT];
}

- (NSNumber *)followerCount
{
    return [_dictionary valueForKey:CLTWITTER_USER_FOLLOWERS_COUNT];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _dictionary = dictionary;
    }
    
    return self;
}

- (id)initWithJSONData:(NSData *)data
{
    if (self = [super init])
    {
        _dictionary = [[CLTwitterEngine sharedEngine] convertJSON:data];
    }
    
    return self;
}

#pragma mark -
#pragma mark Instance Methods

- (void)getFollowersAtCursorPosition:(NSNumber *)cursor completionHandler:(CLUserCursoredArrayHandler)handler;
{
    if (nil == cursor)
    {
        cursor = [NSNumber numberWithInt:-1];
    }
    
    NSString *cursorString = [NSString stringWithFormat:@"%lli", [cursor longLongValue]];
    NSString *urlString = [NSString stringWithFormat:CLTWITTER_GET_FOLLOWERS_ENDPOINT_FORMAT, cursorString, [self screenName]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:urlString]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error != nil)
        {
            handler(nil, nil, error);
        }
        else
        {
            NSDictionary *dict = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSArray *list = [dict valueForKey:CLTWITTER_USER_LIST_IDS];
            NSString *csv = [[list subarrayWithRange:NSMakeRange(0, min([list count], 100))] componentsJoinedByString:@","];
            [CLTwitterUser getUsersWithIds:csv completionHandler:^(NSArray *users, NSError *error) {
                if (error == nil)
                {
                    handler(users, [dict objectForKey:CLTWITTER_USER_NEXT_CURSOR], nil);
                }
                else
                {
                    handler(nil, nil, error);
                }
            }];
        }
    }];
}

- (void)getFollowingAtCursorPosition:(NSNumber *)cursor completionHandler:(CLUserCursoredArrayHandler)handler;
{
    if (nil == cursor)
    {
        cursor = [NSNumber numberWithInt:-1];
    }
    
    NSString *cursorString = [NSString stringWithFormat:@"%lli", [cursor longLongValue]];
    NSString *urlString = [NSString stringWithFormat:CLTWITTER_GET_FOLLOWING_ENDPOINT_FORMAT, cursorString, [self screenName]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:urlString]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error != nil)
        {
            handler(nil, nil, error);
        }
        else
        {
            NSDictionary *dict = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSArray *list = [dict valueForKey:CLTWITTER_USER_LIST_IDS];
            
            NSString *csv = [[list subarrayWithRange:NSMakeRange(0, min([list count], 100))] componentsJoinedByString:@","];
            [CLTwitterUser getUsersWithIds:csv completionHandler:^(NSArray *users, NSError *error) {
                if (error == nil)
                {
                    handler(users, [dict objectForKey:CLTWITTER_USER_NEXT_CURSOR], nil);
                }
                else
                {
                    handler(nil, nil, error);
                }
            }];
        }
    }];
}

#pragma mark -
#pragma mark Class Methods

+ (void)getUserWithScreenName:(NSString *)screenName completionHandler:(CLUserHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_GET_USER_BY_SCREEN_NAME_ENDPOINT_FORMAT, screenName];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:url]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error != nil)
        {
            handler(nil, error);
        }
        else
        {
            handler([[CLTwitterUser alloc] initWithJSONData:data], error);
        }
    }];
}

+ (void)getUserWithId:(NSNumber *)userId completionHandler:(CLUserHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_GET_USER_BY_ID_ENDPOINT_FORMAT, userId];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:url]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error != nil)
        {
            handler(nil, error);
        }
        else
        {
            handler([[CLTwitterUser alloc] initWithJSONData:data], error);
        }
    }];
}

+ (void)getUsersWithIds:(NSString *)usersCsv completionHandler:(CLUserArrayHandler)handler
{
    NSString *urlString = [NSString stringWithFormat:CLTWITTER_GET_USERS_BY_IDS_ENDPOINT_FORMAT, usersCsv];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:urlString]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error != nil)
        {
            handler(nil, error);
        }
        else
        {
            NSArray *array = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:[array count]];
            for (NSDictionary *dictionary in array)
            {
                [retVal addObject:[[CLTwitterUser alloc] initWithDictionary:dictionary]];
            }
            handler(retVal, nil);
        }
    }];
}

@end
