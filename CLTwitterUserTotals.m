//
//  CLTwitterUserTotals.m
//  Sedge
//
//  Created by Casey Liss on 23/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterUserTotals.h"
#import "CLTwitterEngine.h"
#import "CLNetworkUsageController.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEndpoints.h"
#import "GTMHTTPFetcher.h"

@interface CLTwitterUserTotals ()
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

@implementation CLTwitterUserTotals

#pragma mark -
#pragma mark Properties

- (NSNumber *)following
{
    return [_dictionary objectForKey:CLTWITTER_USER_TOTAL_FOLLOWING];
}

- (NSNumber *)followers
{
    return [_dictionary objectForKey:CLTWITTER_USER_TOTAL_FOLLOWERS];
}

- (NSNumber *)tweets
{
    return [_dictionary objectForKey:CLTWITTER_USER_TOTAL_TWEETS];
}

- (NSNumber *)favorites
{
    return [_dictionary objectForKey:CLTWITTER_USER_TOTAL_FAVORITES];
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

+ (void)getUserTotalsWithCompletionHandler:(CLTwitterUserTotalsHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:CLTWITTER_GET_USER_TOTALS_ENDPOINT];
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
            CLTwitterUserTotals *retVal = [[CLTwitterUserTotals alloc] initWithDictionary:dict];
            handler(retVal, error);
        }
    }];
}

@end
