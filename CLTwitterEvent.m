//
//  CLTwitterEvent.m
//  Sedge
//
//  Created by Casey Liss on 5/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterEvent.h"
#import "CLTweetJSONStrings.h"
#import "CLTwitterEngine.h"
#import "CLTweet.h"

@implementation CLTwitterEvent

- (id)target
{
    return [CLTwitterEngine createTwitterObject:[_dictionary objectForKey:CLTWITTER_EVENT_TARGET]];
}

- (id)source
{
    return [CLTwitterEngine createTwitterObject:[_dictionary objectForKey:CLTWITTER_EVENT_SOURCE]];
}

- (CLTwitterEventType)eventType
{
    NSString *type = [_dictionary objectForKey:CLTWITTER_EVENT_EVENTTYPE];
    if ([type isEqualToString:CLTWITTER_EVENT_EVENTTYPE_FAVORITE])
    {
        return CLTwitterEventTypeFavorite;
    }
    else if ([type isEqualToString:CLTWITTER_EVENT_EVENTTYPE_UNFAVORITE])
    {
        return CLTwitterEventTypeUnfavorite;
    }
    else if ([type isEqualToString:CLTWITTER_EVENT_EVENTTYPE_BLOCK])
    {
        return CLTwitterEventTypeBlock;
    }
    else if ([type isEqualToString:CLTWITTER_EVENT_EVENTTYPE_FRIEND])
    {
        return CLTwitterEventTypeFriend;
    }
    else if ([type isEqualToString:CLTWITTER_EVENT_EVENTTYPE_RETWEET])
    {
        return CLTwitterEventTypeRetweet;
    }
    else if ([type isEqualToString:CLTWITTER_EVENT_EVENTTYPE_LIST])
    {
        return CLTwitterEventTypeList;
    }
    else if ([type isEqualToString:CLTWITTER_EVENT_EVENTTYPE_PROFILE])
    {
        return CLTwitterEventTypeProfile;
    }
    else 
    {
        return CLTwitterEventTypeUnknown;
    }
}

+ (BOOL)isThisEntity:(id)parsedJSON
{
    return [parsedJSON objectForKey:CLTWITTER_EVENT_EVENTTYPE] != nil;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        _dictionary = dict;
    }
    
    return self;
}

- (NSString *)description
{
    switch ([self eventType])
    {
        case CLTwitterEventTypeFavorite:
            return [NSString stringWithFormat:@"%@ favorited the tweet: %@", [[self source] name], [[self target] text]];
            break;
        case CLTwitterEventTypeUnfavorite:
            return [NSString stringWithFormat:@"%@ unfavorited the tweet: %@", [[self source] name], [[self target] text]];
            break;
        case CLTwitterEventTypeFriend:
            return [NSString stringWithFormat:@"%@ is now following you.", [[self source] name]];
            break;
        default:
            return [NSString stringWithFormat:@"Event type: %i\nSource: %@\nTarget: %@", [self eventType], [self source], [self target]];
    };
}

@end
