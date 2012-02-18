//
//  CLDirectMessage.m
//  Sedge
//
//  Created by Casey Liss on 6/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLDirectMessage.h"
#import "CLTwitterUser.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEndpoints.h"
#import "CLTweetMedia.h"
#import "CLNetworkUsageController.h"
#import "GTMHTTPFetcher.h"
#import "NSDictionary+UrlEncoding.h"


@implementation CLDirectMessage

#pragma mark Properties

- (NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    return [formatter dateFromString:[_dictionary objectForKey:CLTWITTER_DM_TIMESTAMP]];
}

- (NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    return [formatter stringFromDate:[formatter dateFromString:[_dictionary objectForKey:CLTWITTER_DM_TIMESTAMP]]];
}

- (CLTwitterUser *)sender
{
    return [[CLTwitterUser alloc] initWithDictionary:[_dictionary objectForKey:CLTWITTER_DM_SENDER]];
}

- (CLTwitterUser *)recipient
{
    return [[CLTwitterUser alloc] initWithDictionary:[_dictionary objectForKey:CLTWITTER_DM_RECIPIENT]];
}

- (NSString *)text
{
    return [_dictionary objectForKey:CLTWITTER_DM_TEXT];
}

- (NSString *)expandedText
{
    return [[self media] textWithURLsExpanded];
}

- (NSNumber *)messageId
{
    return [_dictionary objectForKey:CLTWITTER_DM_ID];
}

- (CLTweetMedia *)media
{
    if (_media == nil)
    {
        _media = [[CLTweetMedia alloc] initWithParentText:[self text] mediaData:[_dictionary valueForKey:CLTWITTER_DM_MEDIA]];
    }
    
    return _media;
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

- (void)deleteMessageWithErrorHandler:(CLErrorHandler)handler
{
    NSString *url = [NSString stringWithFormat:CLTWITTER_POST_DELETE_DIRECT_MESSAGE_ENDPOINT_FORMAT, [self messageId]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:url];
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

+ (void)getDirectMessageWithId:(NSNumber *)messageId completionHandler:(CLDirectMessageHandler)handler
{
    NSString *urlString = [NSString stringWithFormat:CLTWITTER_GET_DIRECT_MESSAGE_BY_ID_ENDPOINT_FORMAT, messageId];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:urlString];
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
            CLDirectMessage *message = [[CLDirectMessage alloc] initWithDictionary:dict];
            handler(message, error);
        }
    }];
}

+ (void)postDirectMessageToScreenName:(NSString *)screenName withBody:(NSString *)body completionHandler:(CLDirectMessageHandler)handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CLTWITTER_POST_DIRECT_MESSAGE_ENDPOINT]]; 
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; 
    [request setHTTPMethod:@"POST"];
    NSDictionary *form = [NSDictionary dictionaryWithObjectsAndKeys:
                          body, CLTWITTER_DM_TEXT,
                          screenName, CLTWITTER_DM_NEW_DM_TO, 
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
            CLDirectMessage *dm = [[CLDirectMessage alloc] initWithDictionary:dict];
            handler(dm, error);
        }
        else
        {
            handler(nil, error);
        }
    }];
}

@end
