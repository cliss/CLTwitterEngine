//
//  CLTwitterPhotoLimit.m
//  Sedge
//
//  Created by Casey Liss on 20/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterPhotoLimit.h"
#import "CLTweetJSONStrings.h"

@implementation CLTwitterPhotoLimit

- (NSNumber *)remainingHits
{
    return [_dictionary objectForKey:CLTWITTER_RATE_PHOTO_REMAINING_HITS];
}

- (NSNumber *)resetTimeInSeconds
{
    return [_dictionary objectForKey:CLTWITTER_RATE_PHOTO_RESET_TIME_SECONDS];
}

- (NSDate *)resetDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    return [formatter dateFromString:[_dictionary objectForKey:CLTWITTER_RATE_PHOTO_RESET_DATE]];
}

- (NSNumber *)dailyLimit
{
    return [_dictionary objectForKey:CLTWITTER_RATE_PHOTO_DAILY_LIMIT];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _dictionary = [dictionary copy];
    }
    
    return self;
}

@end
