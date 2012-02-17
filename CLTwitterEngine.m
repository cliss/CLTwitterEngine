//
//  CLTwitterEngine.m
//  Sedge
//
//  Created by Casey Liss on 4/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterEngine.h"
#import "GTMHTTPFetcher.h"
#import "CLTweet.h"
#import "CLDirectMessage.h"
#import "CLTwitterEndpoints.h"
#import "CLNetworkUsageController.h"

@interface CLTwitterEngine ()
- (NSArray *)getTweetsFromJSONData:(NSData *)data;
@end

@implementation CLTwitterEngine

#pragma mark Properties

@synthesize converter;
@synthesize authorizer;

- (BOOL)isReady
{
    return [self authorizer] != nil && [self converter] != nil;
}

#pragma mark -
#pragma mark Class Methods

+ (id)sharedEngine
{
    static dispatch_once_t dispatch;
    static CLTwitterEngine *engine;
    dispatch_once(&dispatch, ^{ engine = [[self alloc] init]; });
    
    return engine;
}

#pragma mark -
#pragma mark Configurable Handlers

- (id)convertJSON:(NSData *)data
{
    return [self converter](data);
}

- (void)authorizeRequest:(NSMutableURLRequest *)request
{
    [self authorizer](request);
}

#pragma mark -
#pragma mark Instance Methods

- (void)getTimeLineWithCompletionHandler:(CLArrayHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:CLTWITTER_GET_TIMELINE_ENDPOINT]];
    [self authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error == nil)
        {
            handler([self getTweetsFromJSONData:data], error);
        }
        else
        {
            handler(nil, error);
        }
    }];
}

- (NSArray *)getTweetsFromJSONData:(NSData *)data
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    NSArray *tweets = [self convertJSON:data];
    for (NSDictionary *tweet in tweets)
    {
        [retVal addObject:[[CLTweet alloc] initWithDictionary:tweet]];
    }
    
    return retVal;
}

- (void)getRecentDirectMessagesWithCompletionHandler:(CLArrayHandler)handler
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    
    NSArray* (^sorter)() = ^{
        return [retVal sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(CLDirectMessage *)a date];
            NSDate *second = [(CLDirectMessage *)b date];
            NSComparisonResult result = [first compare:second];
            if (NSOrderedAscending == result)
            {
                return NSOrderedDescending;
            }
            else if (NSOrderedDescending == result)
            {
                return NSOrderedAscending;
            }
            else
            {
                return NSOrderedSame;
            }
        }];
    };
    
    // Get received DMs
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:CLTWITTER_GET_DIRECT_MESSAGES_RECEIVED_ENDPOINT]];
    [self authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error != nil)
        {
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            handler(nil, error);
        }
        else
        {
            BOOL send = [retVal count] > 0;
            NSArray *messages = [self convertJSON:data];
            for (NSDictionary *dict in messages)
            {
                [retVal addObject:[[CLDirectMessage alloc] initWithDictionary:dict]];
            }
            if (send)
            {
                handler(sorter(), error);
            }
            
        }
    }];
    
    // Get sent DMs
    GTMHTTPFetcher *sentFetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:CLTWITTER_GET_DIRECT_MESSAGES_SENT_ENDPOINT]];
    [self authorizeRequest:[sentFetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [sentFetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error != nil)
        {
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            handler(nil, error);
        }
        else
        {
            BOOL send = [retVal count] > 0;
            NSArray *messages = [self convertJSON:data];
            for (NSDictionary *dict in messages)
            {
                [retVal addObject:[[CLDirectMessage alloc] initWithDictionary:dict]];
            }
            
            if (send)
            {
                handler(sorter(), error);
            }
        }
    }];
}

@end
