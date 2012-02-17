//
//  CLTwitterSavedSearch.m
//  Sedge
//
//  Created by Casey Liss on 13/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterSavedSearch.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEndpoints.h"
#import "CLTwitterEngine.h"
#import "CLNetworkUsageController.h"
#import "NSDictionary+UrlEncoding.h"
#import "GTMHTTPFetcher.h"

@implementation CLTwitterSavedSearch

#pragma mark Properties

- (NSNumber *)searchId
{
    return [_dictionary objectForKey:CLTWITTER_SEARCH_ID];
}

- (NSString *)name
{
    return [_dictionary objectForKey:CLTWITTER_SEARCH_NAME];
}

- (NSString *)query
{
    return [_dictionary objectForKey:CLTWITTER_SEARCH_QUERY];
}

- (NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    return [formatter dateFromString:[_dictionary objectForKey:CLTWITTER_SEARCH_TIMESTAMP]];
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

#pragma mark -
#pragma mark Instance Methods

- (void)deleteWithErrorHandler:(CLErrorHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:[NSString stringWithFormat:CLTWITTER_DELETE_SEARCH_ENDPOINT_FORMAT, [self searchId]]];
    NSLog(@"URL: %@", [[fetcher mutableRequest] URL]);
    [[fetcher mutableRequest] setHTTPMethod:@"POST"];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        handler(error);
    }];
}

#pragma mark -
#pragma mark Class Methods

+ (void)getSavedSearchTermsWithHandler:(CLArrayHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:CLTWITTER_GET_SAVED_SEARCHES_ENDPOINT];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error != nil)
        {
            handler(nil, error);
        }
        else
        {
            NSArray *sourceArray = [[CLTwitterEngine sharedEngine] convertJSON:data];
            NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:[sourceArray count]];
            for (NSDictionary *dict in sourceArray)
            {
                [retVal addObject:[[CLTwitterSavedSearch alloc] initWithDictionary:dict]];
            }
            
            handler(retVal, error);
        }
    }];
}
        
+ (void)getSavedSearchWithId:(NSNumber *)searchId completionHandler:(CLTwitterSavedSearchHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:[NSString stringWithFormat:CLTWITTER_GET_SAVED_SEARCH_ENDPOINT_FORMAT, searchId]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error != nil)
        {
            handler(nil, error);
        }
        else
        {
            NSDictionary *dict = [[CLTwitterEngine sharedEngine] convertJSON:data];
            handler([[CLTwitterSavedSearch alloc] initWithDictionary:dict], error);
        }
    }];
}

+ (void)createSavedSearchWithQuery:(NSString *)query completionHandler:(CLTwitterSavedSearchHandler)handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CLTWITTER_CREATE_SAVED_SEARCH_ENDPOINT]]; 
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; 
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[[NSDictionary dictionaryWithObjectsAndKeys:query, CLTWITTER_SEARCH_QUERY, nil] urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
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
            handler([[CLTwitterSavedSearch alloc] initWithDictionary:dict], error);
        }
    }];
}

@end
