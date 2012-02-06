//
//  CLTweetMedia.m
//  Sedge
//
//  Created by Casey Liss on 4/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTweetMedia.h"
#import "CLTweetJSONStrings.h"
#import "CLTweet.h"

@implementation CLTweetMedia

#pragma mark -
#pragma mark Properties

- (NSArray *)hashTags
{
    return [_dictionary objectForKey:CLTWITTER_TWEET_MEDIA_HASHTAGS];
}

- (NSArray *)urls
{
    return [_dictionary objectForKey:CLTWITTER_TWEET_MEDIA_URLS];
}

- (BOOL)hasUrls
{
    return [[self urls] count];
}

- (NSArray *)mentions
{
    return [_dictionary objectForKey:CLTWITTER_TWEET_MEDIA_MENTIONS];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithParentText:(NSString *)text mediaData:(NSDictionary *)data
{
    if (self = [super init])
    {
        _text = text;
        _dictionary = data;
    }
    
    return self;
}

- (NSString *)textWithURLsExpanded
{
    if (![self hasUrls])
    {
        return _text;
    }
    
    NSMutableString *retVal = [_text mutableCopy];
    for (NSDictionary *url in [self urls])
    {
        [retVal replaceOccurrencesOfString:[url objectForKey:CLTWITTER_TWEET_MEDIA_URL_URL]
                                withString:[url objectForKey:CLTWITTER_TWEET_MEDIA_DISPLAY_URL]
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [retVal length])];
    }
    
    return retVal;
}

@end
