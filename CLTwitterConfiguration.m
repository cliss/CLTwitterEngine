//
//  CLTwitterConfiguration.m
//  Sedge
//
//  Created by Casey Liss on 17/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterConfiguration.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEndpoints.h"
#import "CLTwitterEngine.h"
#import "CLNetworkUsageController.h"
#import "CLTwitterPhotoSize.h"
#import "GTMHTTPFetcher.h"

@implementation CLTwitterConfiguration

#pragma mark Properties

- (NSNumber *)maxMediaPerUpload
{
    return [_dictionary objectForKey:CLTWITTER_CONFIGURATION_MAX_MEDIA_PER_UPLOAD];
}

- (NSNumber *)photoSizeLimit
{
    return [_dictionary objectForKey:CLTWITTER_CONFIGURATION_PHOTO_SIZE_LIMIT];
}

- (NSNumber *)mediaShortUrlLength
{
    return [_dictionary objectForKey:CLTWITTER_CONFIGURATION_MEDIA_SHORT_URL_LENGTH];
}

- (NSNumber *)insecureShortUrlLength
{
    return [_dictionary objectForKey:CLTWITTER_CONFIGURATION_INSECURE_SHORT_URL_LENGTH];
}

- (NSNumber *)secureShortUrlLength
{
    return [_dictionary objectForKey:CLTWITTER_CONFIGURATION_SECURE_SHORT_URL_LENGTH];
}

- (NSArray *)nonUsernamePaths
{
    return [_dictionary objectForKey:CLTWITTER_CONFIGURATION_NON_USERNAME_PATHS];
}

- (NSDictionary *)photoSizes
{
    NSDictionary *sizes = [_dictionary objectForKey:CLTWITTER_CONFIGURATION_PHOTO_SIZES];
    NSMutableDictionary *retVal = [[NSMutableDictionary alloc] initWithCapacity:[sizes count]];
    
    for (NSString *key in sizes)
    {
        CLTwitterPhotoSize *photoSize = [[CLTwitterPhotoSize alloc] initWithDictionary:[sizes valueForKey:key]];
        [retVal setValue:photoSize forKey:key];
    }
    
    return retVal;
}

#pragma mark -
#pragma mark Instance Methods

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

+ (void)getTwitterConfigurationWithHandler:(CLTwitterConfigurationHandler)handler
{
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:CLTWITTER_GET_CONFIGURATION];
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
            handler([[CLTwitterConfiguration alloc] initWithDictionary:dict], error);
        }
    }];
}

@end
