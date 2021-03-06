//
//  CLTwitterEngine.m
//  Sedge
//
//  Created by Casey Liss on 4/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <objc/objc-runtime.h>
#import "CLTwitterEngine.h"
#import "CLTweet.h"
#import "CLDirectMessage.h"
#import "CLTwitterEndpoints.h"
#import "CLNetworkUsageController.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEvent.h"
#import "CLTwitterEntity.h"
#import "GTMHTTPFetcher.h"
#import "NSDictionary+UrlEncoding.h"
#import "NSURLConnection+Blocks.h"
#import "CLReflection.h"

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

+ (id)createTwitterObject:(id)parsedJSON
{
    __block id retVal = nil;
    
    [CLReflection forClassesConformingToProtocol:@protocol(CLTwitterEntity)
                                   performAction:^(id item) {
                                       Class c = (Class)item;
                                       if (retVal == nil && [c isThisEntity:parsedJSON])
                                       {
                                           retVal = [[c alloc] initWithDictionary:parsedJSON];
                                       }
                                   }];

    return retVal;
    
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

- (void)getMentionsWithCompletionHandler:(CLArrayHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:CLTWITTER_GET_MENTIONS_ENDPOINT]];
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

- (void)getRetweetsOfMeWithCompletionHandler:(CLArrayHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:CLTWITTER_GET_RETWEETS_OF_ME_ENDPOINT]];
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

// NOTE: THIS METHOD IS UNTESTED.
- (void)getPendingFollowRequestsOfMeWithHandler:(CLArrayHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:CLTWITTER_GET_PENDING_FOLLOW_REQUESTS_OF_ME_ENDPOINT];
    [self authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error)
        {
            handler(nil, error);
        }
        else 
        {
            NSDictionary *dict = [self convertJSON:data];
            handler([dict objectForKey:CLTWITTER_USER_LIST_IDS], error);
        }
    }];
}

// NOTE: THIS METHOD IS UNTESTED.
- (void)getMyPendingFollowRequestsWithHandler:(CLArrayHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:CLTWITTER_GET_MY_PENDING_FOLLOW_REQUESTS_ENDPOINT];
    [self authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error)
        {
            handler(nil, error);
        }
        else 
        {
            NSDictionary *dict = [self convertJSON:data];
            handler([dict objectForKey:CLTWITTER_USER_LIST_IDS], error);
        }
    }];
}

- (void)followUserWithScreenName:(NSString *)screenName handler:(CLUserHandler)handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CLTWITTER_POST_START_FOLLOWING_USER_ENDPOINT]]; 
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; 
    [request setHTTPMethod:@"POST"];
    NSDictionary *form = [NSDictionary dictionaryWithObjectsAndKeys:
                          screenName, CLTWITTER_USER_SCREEN_NAME, 
                          nil];
    [request setHTTPBody:[[form urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (!error)
        {
            NSDictionary *dict = [[CLTwitterEngine sharedEngine] convertJSON:data];
            handler([[CLTwitterUser alloc] initWithDictionary:dict], error);
        }
        else
        {
            handler(nil, error);
        }
    }];

}

- (void)stopFollowingUserWithScreenName:(NSString *)screenName errorHandler:(CLErrorHandler)handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CLTWITTER_POST_STOP_FOLLOWING_USER_ENDPOINT]]; 
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; 
    [request setHTTPMethod:@"POST"];
    NSDictionary *form = [NSDictionary dictionaryWithObjectsAndKeys:
                          screenName, CLTWITTER_USER_SCREEN_NAME, 
                          nil];
    [request setHTTPBody:[[form urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        handler(error);
    }];
}

- (void)getMyFavoritesPage:(NSNumber *)page withCompletionHandler:(CLArrayHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_GET_MY_FAVORITES_ENDPOINT_FORMAT, page];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:url];
    [self authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        if (error)
        {
            handler(nil, error);
        }
        else 
        {
            NSArray *array = [self convertJSON:data];
            NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:[array count]];
            
            for (NSDictionary *dict in array)
            {
                [retVal addObject:[[CLTweet alloc] initWithDictionary:dict]];
            }
            
            handler(retVal, error);
        }
    }];
}

- (void)getBlockedUsersWithCompletionHandler:(CLArrayHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:CLTWITTER_GET_BLOCKED_USER_IDS_ENDPOINT];
    [self authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error)
        {
            handler(nil, error);
        }
        else 
        {
            NSArray *ids = [self convertJSON:data];
            [CLTwitterUser getUsersWithIds:ids completionHandler:handler];
        }
    }];
}

- (void)updateProfileWithName:(NSString *)name 
                          url:(NSURL *)url 
                     location:(NSString *)location 
                  description:(NSString *)description
            completionHandler:(CLUserHandler)handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CLTWITTER_POST_PROFILE_UPDATE_ENDPOINT]]; 
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; 
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"true", CLTWITTER_INCLUDE_ENTITIES, nil];
    if (name)
    {
        [dict setValue:name forKey:CLTWITTER_USER_REAL_NAME];
    }
    if (url)
    {
        [dict setValue:[url absoluteString] forKey:CLTWITTER_USER_PERSONAL_URL];
    }
    if (location)
    {
        [dict setValue:location forKey:CLTWITTER_USER_LOCATION];
    }
    if (description)
    {
        [dict setValue:description forKey:CLTWITTER_USER_DESCRIPTION];
    }
    [request setHTTPBody:[[dict urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
            NSDictionary *userDict = [self convertJSON:data];
            handler([[CLTwitterUser alloc] initWithDictionary:userDict], error);
        }
    }];
}

- (void)updateProfileImage:(NSImage *)image withErrorHandler:(CLErrorHandler)handler
{
    NSMutableData *data = [NSMutableData new];
    // Inline method to add headers to the data.
    void(^addHeader)(NSDictionary *headers) = ^(NSDictionary *headers)
    {
        for (NSString *key in headers)
        {
            [data appendData:[[NSString stringWithFormat:@"%@: %@\r\n", key, [headers objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    };
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:CLTWITTER_POST_PROFILE_IMAGE_UPDATE_ENDPOINT]];
    
    NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
    // Image
    NSBitmapImageRep *imageRep = [[image representations] objectAtIndex:0];
    NSData *imageData = [imageRep representationUsingType:NSPNGFileType properties:nil];
    NSDictionary *imageHeaders = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"form-data; name=\"image\"; filename=\"./image.png\"", @"Content-Disposition",
                                  @"application/octet-stream", @"Content-Type",
                                  //@"base64", @"Content-Transfer-Encoding",
                                  nil];
    
    // Top boundary
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // Image
    addHeader(imageHeaders);
    [data appendData:imageData];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // Final boundary
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [[CLNetworkUsageController sharedController] beginNetworkRequest];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [[CLNetworkUsageController sharedController] endNetworkRequest];
        handler(error);
    }];
}

#pragma mark -
#pragma mark Streaming

- (void)startStreamingWithTweetHandler:(CLTwitterEntityHandler)handler
{
    if (_streamingConnection != nil)
    {
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CLTWITTER_STREAMING_ENDPOINT]];
    [self authorizeRequest:request];
    _streamingConnection = [[NSURLConnection alloc] initWithRequest:request
                                                       dataReceiver:^(NSData *data) {
                                                           if ([data length] > 2)
                                                           {
                                                               id json = [self convertJSON:data];
                                                               id entity = [CLTwitterEngine createTwitterObject:json];
                                                                                                                              
                                                               if (entity != nil)
                                                               {
                                                                   handler(entity);
                                                               }
                                                               else
                                                               {
                                                                   NSLog(@"CANNOT HANDLE JSON:\n%@", json);
                                                               }
                                                           }
                                                       } 
                                                       erorrHandler:^(NSError *error) {
                                                           
                                                       }];
    [_streamingConnection start];
}

@end
