//
//  CLTwitterUser.m
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterUser.h"
#import "CLTweetJSONStrings.h"
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

- (void)getFollowersAtCursorPosition:(NSNumber *)cursor completionHandler:(CLUserArrayHandler)handler;
{
    if (nil == cursor)
    {
        cursor = [NSNumber numberWithInt:-1];
    }
    
    NSString *cursorString = [NSString stringWithFormat:@"%lli", [cursor longLongValue]];
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1/followers/ids.json?cursor=%@&screen_name=%@", cursorString, [self screenName]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:urlString]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error != nil)
        {
            handler(nil, nil, error);
        }
        else
        {
            NSMutableArray *retVal = [[NSMutableArray alloc] init];
            NSDictionary *dict = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSArray *list = [dict valueForKey:CLTWITTER_USER_LIST_IDS];
            dispatch_group_t fetchGroup = dispatch_group_create();
            for (int i = 0; i < min([list count], 100); ++i)
            {
                dispatch_group_enter(fetchGroup);
                [CLTwitterUser getUserWithId:[list objectAtIndex:i] completionHandler:^(CLTwitterUser *user, NSError *error) {
                    if (user != nil)
                    {
                        [retVal addObject:user];
                    }
                    dispatch_group_leave(fetchGroup);
                }];
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_group_wait(fetchGroup, DISPATCH_TIME_FOREVER);
                dispatch_release(fetchGroup);
                handler(retVal, [dict objectForKey:CLTWITTER_USER_NEXT_CURSOR], nil);
            });
        }
    }];
}

- (void)getFollowingAtCursorPosition:(NSNumber *)cursor completionHandler:(CLUserArrayHandler)handler;
{
    if (nil == cursor)
    {
        cursor = [NSNumber numberWithInt:-1];
    }
    
    NSString *cursorString = [NSString stringWithFormat:@"%lli", [cursor longLongValue]];
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1/friends/ids.json?cursor=%@&screen_name=%@", cursorString, [self screenName]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:urlString]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error != nil)
        {
            handler(nil, nil, error);
        }
        else
        {
            NSMutableArray *retVal = [[NSMutableArray alloc] init];
            NSDictionary *dict = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSArray *list = [dict valueForKey:CLTWITTER_USER_LIST_IDS];
            dispatch_group_t fetchGroup = dispatch_group_create();
            for (int i = 0; i < min([list count], 100); ++i)
            {
                dispatch_group_enter(fetchGroup);
                [CLTwitterUser getUserWithId:[list objectAtIndex:i] completionHandler:^(CLTwitterUser *user, NSError *error) {
                    if (user != nil)
                    {
                        [retVal addObject:user];
                    }
                    dispatch_group_leave(fetchGroup);
                }];
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_group_wait(fetchGroup, DISPATCH_TIME_FOREVER);
                dispatch_release(fetchGroup);
                handler(retVal, [dict objectForKey:CLTWITTER_USER_NEXT_CURSOR], nil);
            });
        }
    }];
}

#pragma mark -
#pragma mark Class Methods

+ (void)getUserWithScreenName:(NSString *)screenName completionHandler:(CLUserHandler)handler
{
    NSString *url = [NSString stringWithFormat:@"http://api.twitter.com/1/users/show.json?screen_name=%@&include_entities=true", screenName];
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
    NSString *url = [NSString stringWithFormat:@"http://api.twitter.com/1/users/show.json?user_id=%@&include_entities=true", userId];
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

@end
