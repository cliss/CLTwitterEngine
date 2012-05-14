//
//  CLFriendList.m
//  Sedge
//
//  Created by Casey Liss on 13/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLFriendList.h"
#import "CLTweetJSONStrings.h"

@implementation CLFriendList

#pragma mark -
#pragma mark Class Methods

+ (BOOL)isThisEntity:(id)parsedJSON
{
    return [parsedJSON valueForKey:CLTWITTER_OBJECT_TYPE_FRIENDS] != nil;
}

#pragma mark -
#pragma mark Instance Methods

- (NSArray *)friends
{
    return _friends;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    NSArray *array = [dictionary valueForKey:CLTWITTER_OBJECT_TYPE_FRIENDS];
    if (self = [super init])
    {
        _friends = array;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Friends list with %u entries.", [_friends count]];
}


@end
