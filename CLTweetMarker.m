//
//  CLTweetMarker.m
//  Sedge
//
//  Created by Casey Liss on 12/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTweetMarker.h"
#import "CLTwitterEngine.h"
#import "CLTwitterEndpoints.h"
#import "GTMHTTPFetcher.h"

#define OAUTH_HEADER_FIELD @"Authorization"
#define OAUTH_PROXY_HEADER_FIELD @"X-Verify-Credentials-Authorization"
#define OAUTH_SERVICE_PROVIDER @"X-Auth-Service-Provider"

@implementation CLTweetMarker

+ (void)getLastReadForUsername:(NSString *)user inCollection:(NSString *)collection withApiKey:(NSString *)key completionHandler:(CLTweetMarkerGetHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWEETMARKER_GET_LAST_READ_FORMAT, user, collection, key];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:url];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error != nil)
        {
            handler(nil, error);
        }
        else
        {
            NSString *tweetIdString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            handler([NSNumber numberWithLongLong:[tweetIdString longLongValue]], error);
        }
    }];
}

+ (void)markLastReadAsTweet:(NSNumber *)tweetId
                forUsername:(NSString *)user
               inCollection:(NSString *)collection 
                 withApiKey:(NSString *)key
          completionHandler:(CLTweetMarkerSaveHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWEETMARKER_MARK_LAST_READ_FORMAT, user, collection, key];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:request];
    
    // Move the oauth info to the correct header for proxying.
    NSString *oauthInfo = [request valueForHTTPHeaderField:OAUTH_HEADER_FIELD];
    [request setValue:nil forHTTPHeaderField:OAUTH_HEADER_FIELD];
    [request setValue:oauthInfo forHTTPHeaderField:OAUTH_PROXY_HEADER_FIELD];
    // Set the service provider.
    [request setValue:CLTWITTER_VERIFY_CREDENTIALS forHTTPHeaderField:OAUTH_SERVICE_PROVIDER];
    
    // Set up the request itself.
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString stringWithFormat:@"%@", tweetId] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Do it.
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error != nil)
        {
            handler(NO, error);
        }
        else
        {
            handler(YES, error);
        }
    }];
}

@end
