//
//  CLDirectMessage.m
//  Sedge
//
//  Created by Casey Liss on 6/2/12.
//  Copyright (c) 2012 Ironworks Consulting. All rights reserved.
//

#import "CLDirectMessage.h"
#import "CLTwitterEngine.h"
#import "CLTwitterUser.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEndpoints.h"
#import "CLTweetMedia.h"
#import "GTMHTTPFetcher.h"


@implementation CLDirectMessage

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

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _dictionary = dictionary;
    }
    
    return self;
}

+ (void)getDirectMessageWithId:(NSNumber *)messageId completionHandler:(CLDirectMessageHandler)handler
{
    NSString *urlString = [NSString stringWithFormat:CLTWITTER_GET_DIRECT_MESSAGE_BY_ID_ENDPOINT_FORMAT, messageId];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:[NSURL URLWithString:urlString]];
    [[CLTwitterEngine sharedEngine] authorizeRequest:[fetcher mutableRequest]];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
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

@end
