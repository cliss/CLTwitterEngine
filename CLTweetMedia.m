//
//  CLTweetMedia.m
//  Sedge
//
//  Created by Casey Liss on 4/2/12.
//  Copyright (c) 2012 Ironworks Consulting. All rights reserved.
//

#import "CLTweetMedia.h"
#import "CLTweetJSONStrings.h"
#import "CLTweet.h"

@implementation CLTweetMedia

@synthesize parent = _parent;

#pragma mark -
#pragma mark Properties

- (NSArray *)hashTags
{
    return [_dictionary objectForKey:CLTWEET_MEDIA_HASHTAGS];
}

- (NSArray *)urls
{
    return [_dictionary objectForKey:CLTWEET_MEDIA_URLS];
}

- (BOOL)hasUrls
{
    return [[self urls] count];
}

- (NSArray *)mentions
{
    return [_dictionary objectForKey:CLTWEET_MEDIA_MENTIONS];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithParent:(CLTweet *)tweet data:(NSDictionary *)data
{
    if (self = [super init])
    {
        [self setParent:tweet];
        _dictionary = data;
    }
    
    return self;
}

- (NSString *)expandUrlsInParent
{
    if ([self parent] == nil)
    {
        return nil;
    }
    else if (![self hasUrls])
    {
        return [[self parent] text];
    }
    
    NSMutableString *retVal = [[[self parent] text] mutableCopy];
    for (NSDictionary *url in [self urls])
    {
        [retVal replaceOccurrencesOfString:[url objectForKey:CLTWEET_MEDIA_URL_URL]
                                withString:[url objectForKey:CLTWEET_MEDIA_URL_DISPLAY]
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [retVal length])];
    }
    
    return retVal;
}

@end
