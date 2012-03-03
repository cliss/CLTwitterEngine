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
#import "CLNetworkUsageController.h"
#import "GTMHTTPFetcher.h"

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
    return [_dictionary objectForKey:CLTWITTER_LIST_SUBSCRIBERS];
}

- (NSNumber *)members
{
    return [_dictionary objectForKey:CLTWITTER_LIST_MEMBERS];
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

@end
