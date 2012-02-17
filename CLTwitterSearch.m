//
//  CLTwitterSearch.m
//  Sedge
//
//  Created by Casey Liss on 15/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterSearch.h"
#import "CLTwitterEngine.h"
#import "CLTwitterEndpoints.h"
#import "CLTweetJSONStrings.h"
#import "CLTweet.h"
#import "CLNetworkUsageController.h"
#import "GTMHTTPFetcher.h"

#pragma mark Private Category

@interface CLTwitterSearch ()

@property (readonly) NSString *olderUrl;
@property (readonly) NSString *refreshUrl;

@end

#pragma mark -
@implementation CLTwitterSearch

#pragma mark -
#pragma mark Properties

- (NSString *)olderUrl
{
    return [NSString stringWithFormat:@"%@%@", 
            CLTWITTER_GET_SEARCH_BASE_ENDPOINT, 
            [_dictionary objectForKey:CLTWITTER_SEARCH_NEXT_PAGE_QUERY_STRING]];
}

- (NSString *)refreshUrl
{
    return [NSString stringWithFormat:@"%@%@",
            CLTWITTER_GET_SEARCH_BASE_ENDPOINT,
            [_dictionary objectForKey:CLTWITTER_SEARCH_REFRESH_QUERY_STRING]];
}

- (NSArray *)results
{
    NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:[[_dictionary objectForKey:CLTWITTER_SEARCH_RESULTS] count]];
    for (NSDictionary *dict in [_dictionary objectForKey:CLTWITTER_SEARCH_RESULTS])
    {
        [retVal addObject:[[CLTweet alloc] initWithDictionary:dict]];
    }
    return retVal;
}

- (BOOL)olderTweetsAvailable
{
    return 99 <= [[_dictionary objectForKey:CLTWITTER_SEARCH_RESULTS] count];
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

+ (void)beginSearchWithQuery:(NSString *)query completionHandler:(CLSearchResultsHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_GET_SEARCH_ENDPOINT_FORMAT, 
                     CLTWITTER_GET_SEARCH_BASE_ENDPOINT, 
                     [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:url];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error != nil)
        {
            handler(nil, error);
        }
        else
        {
            NSDictionary *result = [[CLTwitterEngine sharedEngine] convertJSON:data];
            handler([[CLTwitterSearch alloc] initWithDictionary:result], error);
        }
    }];
}

#pragma mark -
#pragma mark Instance Methods

- (void)getOlderSearchResultsWithCompletionHandler:(CLSearchResultsHandler)handler
{
    NSLog(@"%@", [self olderUrl]);
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:[self olderUrl]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error != nil)
        {
            handler(nil, error);
        }
        else
        {
            NSDictionary *result = [[CLTwitterEngine sharedEngine] convertJSON:data];
            handler([[CLTwitterSearch alloc] initWithDictionary:result], error);
        }
    }];
}

- (void)getNewerSearchResultsWithCompletionHandler:(CLSearchResultsHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:[self refreshUrl]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error != nil)
        {
            handler(nil, error);
        }
        else
        {
            NSDictionary *result = [[CLTwitterEngine sharedEngine] convertJSON:data];
            handler([[CLTwitterSearch alloc] initWithDictionary:result], error);
        }
    }];
}

@end
