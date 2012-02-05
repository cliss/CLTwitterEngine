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

@interface CLTwitterEngine ()
- (NSArray *)getTweetsFromJSONData:(NSData *)data;
@end

@implementation CLTwitterEngine

@synthesize converter;
@synthesize authorizer;

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
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"]];
    [self authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
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
    NSError *error;
    NSArray *tweets = [NSJSONSerialization JSONObjectWithData:data
                                                      options:kNilOptions
                                                        error:&error];
    for (NSDictionary *tweet in tweets)
    {
        [retVal addObject:[[CLTweet alloc] initWithDictionary:tweet]];
    }
    
    return retVal;
}

@end
