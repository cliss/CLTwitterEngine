//
//  CLDeletedTweet.m
//  Sedge
//
//  Created by Casey Liss on 13/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLDeletedTweet.h"
#import "CLTweet.h"
#import "CLTwitterUser.h"
#import "CLTweetJSONStrings.h"

@implementation CLDeletedTweet

- (NSNumber *)tweetId
{
    return _tweetId;
}

- (NSNumber *)userId
{
    return _userId;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        NSDictionary *dict = dictionary;
        if ([dict valueForKey:CLTWITTER_OBJECT_TYPE_DELETED_TWEET] != nil)
        {
            dict = [dictionary valueForKey:CLTWITTER_OBJECT_TYPE_DELETED_TWEET];
            if ([dict valueForKey:CLTWITTER_NESTED_OBJECT_STATUS] != nil)
            {
                dict = [dict valueForKey:CLTWITTER_NESTED_OBJECT_STATUS];
            }
        }
        
        _tweetId = [dict valueForKey:CLTWITTER_TWEET_ID];
        _userId = [dict valueForKey:CLTWITTER_USER_ID];
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Deleted Tweet, #%@ by user %@.", _tweetId, _userId];
}

+ (BOOL)isThisEntity:(id)parsedJSON
{
    return [parsedJSON valueForKey:CLTWITTER_OBJECT_TYPE_DELETED_TWEET] != nil; 
}

@end
