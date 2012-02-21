//
//  CLTwitterRateLimitStatus.m
//  Sedge
//
//  Created by Casey Liss on 20/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterRateLimitStatus.h"
#import "CLTwitterPhotoLimit.h"
#import "CLTwitterEngine.h"
#import "CLNetworkUsageController.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEndpoints.h"
#import "GTMHTTPFetcher.h"

@interface CLTwitterRateLimitStatus ()
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

@implementation CLTwitterRateLimitStatus

#pragma mark -
#pragma mark Properties

- (NSNumber *)remainingHits
{
    return [_dictionary objectForKey:CLTWITTER_RATE_REMAINING_HITS];
}

- (NSNumber *)resetTimeInSeconds
{
    return [_dictionary objectForKey:CLTWITTER_RATE_RESET_TIME_SECONDS];
}

- (NSNumber *)hourlyLimit
{
    return [_dictionary objectForKey:CLTWITTER_RATE_HOURLY_LIMIT];
}

- (NSDate *)resetDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    return [formatter dateFromString:[_dictionary objectForKey:CLTWITTER_RATE_RESET_DATE]];
}

- (CLTwitterPhotoLimit *)photoLimit
{
    if (!_photoLimit)
    {
        _photoLimit = [[CLTwitterPhotoLimit alloc] initWithDictionary:[_dictionary objectForKey:CLTWITTER_RATE_PHOTO_LIMIT]];
    }
    
    return _photoLimit;
}

#pragma mark -
#pragma mark Initializaiton

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

+ (void)getRateLimitStatusWithCompletionHandler:(CLTwitterRateLimitHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:CLTWITTER_GET_RATE_LIMIT];
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
            handler([[CLTwitterRateLimitStatus alloc] initWithDictionary:dict], error);
        }
    }];
}

@end
