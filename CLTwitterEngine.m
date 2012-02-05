//
//  CLTwitterEngine.m
//  Sedge
//
//  Created by Casey Liss on 4/2/12.
//  Copyright (c) 2012 Ironworks Consulting. All rights reserved.
//

#import "CLTwitterEngine.h"
#import "GTMHTTPFetcher.h"
#import "CLTweet.h"

@implementation CLTwitterEngine

@synthesize converter;
@synthesize authorizer;

+ (id)sharedEngine
{
    static dispatch_once_t dispatch;
    static CLTwitterEngine *engine;
    dispatch_once(&dispatch, ^{ engine = [[self alloc] init]; });
    
    return engine;
}

- (id)convertJSON:(NSData *)data
{
    return [self converter](data);
}

- (void)authorizeRequest:(NSMutableURLRequest *)request
{
    [self authorizer](request);
}

- (void)getTimeLineWithCompletionHandler:(arrayHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"]];
    [self authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error == nil)
        {
            handler([CLTweet getTweetsFromJSONData:data], error);
        }
        else
        {
            handler(nil, error);
        }
    }];
}

@end
