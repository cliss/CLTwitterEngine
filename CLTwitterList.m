//
//  CLTwitterList.m
//  Sedge
//
//  Created by Casey Liss on 2/3/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterList.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEndpoints.h"
#import "CLTwitterUser.h"
#import "CLTweet.h"
#import "CLNetworkUsageController.h"
#import "GTMHTTPFetcher.h"
#import "NSDictionary+UrlEncoding.h"

@interface CLTwitterList ()
- (void)postSubscriptionChangeToUrl:(NSString *)url errorHandler:(CLErrorHandler)handler;
@end

@implementation CLTwitterList

- (NSString *)slug
{
    return [_dictionary objectForKey:CLTWITTER_LIST_SLUG];
}

- (NSString *)name
{
    return [_dictionary objectForKey:CLTWITTER_LIST_NAME];
}

- (NSString *)url
{
    return [_dictionary objectForKey:CLTWITTER_LIST_URL];
}

- (NSNumber *)subscribers
{
    return [_dictionary objectForKey:CLTWITTER_LIST_SUBSCRIBERS_COUNT];
}

- (NSNumber *)members
{
    return [_dictionary objectForKey:CLTWITTER_LIST_MEMBERS_COUNT];
}

- (NSString *)mode
{
    return [_dictionary objectForKey:CLTWITTER_LIST_MODE];
}

- (NSString *)fullname
{
    return [_dictionary objectForKey:CLTWITTER_LIST_FULL_NAME];
}

- (NSString *)desc
{
    return [_dictionary objectForKey:CLTWITTER_LIST_DESCRIPTION];
}

- (NSNumber *)listId
{
    return [_dictionary objectForKey:CLTWITTER_LIST_ID];
}

- (CLTwitterUser *)user
{
    CLTwitterUser *retVal = [[CLTwitterUser alloc] initWithDictionary:[_dictionary objectForKey:CLTWITTER_LIST_USER]];
    return retVal;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _dictionary = [dictionary copy];
    }
    
    return self;
}

#pragma mark -
#pragma mark Instance Methods

- (void)getTimelineOnPage:(NSUInteger)page tweetsPerPage:(NSUInteger)pageLength completionHandler:(CLArrayHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_GET_LIST_TIMELINE_ENDPOINT_FORMAT,
                     [self listId],
                     page,
                     pageLength];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:url];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error)
        {
            handler(nil, error);
        }
        else 
        {
            NSArray *array = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:[array count]];
            for (NSDictionary *dict in array)
            {
                CLTweet *tweet = [[CLTweet alloc] initWithDictionary:dict];
                [retVal addObject:tweet];
            }
            
            handler(retVal, error);
        }
    }];
}

- (void)getListMembersWithCompletionHandler:(CLArrayHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_GET_LIST_MEMBERS_ENDPOINT_FORMAT, [self listId]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:url];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error)
        {
            handler(nil, error);
        }
        else 
        {
            NSDictionary *dict = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSArray *array = [dict objectForKey:CLTWITTER_LIST_MEMBERS];
            NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:[array count]];
            for (NSDictionary *dict in array)
            {
                CLTwitterUser *user = [[CLTwitterUser alloc] initWithDictionary:dict];
                [retVal addObject:user];
            }
            
            handler(retVal, error);
        }
    }];
}

- (void)subscribeWithErrorHandler:(CLErrorHandler)handler
{
    [self postSubscriptionChangeToUrl:CLTWITTER_POST_LIST_SUBSCRIBE_ENDPOINT errorHandler:handler];
}

- (void)unsubscribeWithErrorHandler:(CLErrorHandler)handler
{
    [self postSubscriptionChangeToUrl:CLTWITTER_POST_LIST_UNSUBSCRIBE_ENDPOINT errorHandler:handler];
}

- (void)postSubscriptionChangeToUrl:(NSString *)url errorHandler:(CLErrorHandler)handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]]; 
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; 
    [request setHTTPMethod:@"POST"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [self listId], CLTWITTER_LIST_ID_WHEN_POSTING, 
                            nil];
    [request setHTTPBody:[[params urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        handler(error);
    }];
}

- (void)getSubscribersWithCompletionHandler:(CLArrayHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_GET_LIST_SUBSCRIBERS_ENDPOINT_FORMAT, [self listId]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:url];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error)
        {
            handler(nil, error);
        }
        else 
        {
            NSDictionary *dict = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSArray *array = [dict valueForKey:CLTWITTER_LIST_SUBSCRIBERS];
            NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:[array count]];
            for (NSDictionary *userDict in array)
            {
                CLTwitterUser *user = [[CLTwitterUser alloc] initWithDictionary:userDict];
                [retVal addObject:user];
            }
            
            handler(retVal, nil);
        }
    }];
}

#pragma mark -
#pragma mark Class Methods

+ (void)getAllListsWithCompletionHandler:(CLArrayHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:CLTWITTER_GET_ALL_LISTS_ENDPOINT];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error)
        {
            handler(nil, error);
        }
        else 
        {
            NSArray *array = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:[array count]];
            for (NSDictionary *dict in array)
            {
                CLTwitterList *list = [[CLTwitterList alloc] initWithDictionary:dict];
                [retVal addObject:list];
            }
            
            handler(retVal, error);
        }
    }];
}

+ (void)getListsForUser:(NSString *)userName withCompletionHandler:(CLArrayHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_GET_USER_LISTS_ENDPOINT_FORMAT, userName];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:url];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error)
        {
            handler(nil, error);
        }
        else 
        {
            NSArray *array = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:[array count]];
            for (NSDictionary *dict in array)
            {
                CLTwitterList *list = [[CLTwitterList alloc] initWithDictionary:dict];
                [retVal addObject:list];
            }
            
            handler(retVal, error);
        }
    }];
}

+ (void)getListWithId:(NSNumber *)listId completionHandler:(CLTwitterListHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_GET_LIST_BY_ID_ENDPOINT_FORMAT, listId];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:url];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error)
        {
            handler(nil, error);
        }
        else 
        {
            NSDictionary *dict = [[CLTwitterEngine sharedEngine] convertJSON:data];
            CLTwitterList *retVal = [[CLTwitterList alloc] initWithDictionary:dict];
            handler(retVal, error);
        }
    }];
}

@end
