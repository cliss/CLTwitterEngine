//
//  CLTwitterUser.m
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterUser.h"
#import "CLTweetJSONStrings.h"

@implementation CLTwitterUser

#pragma mark Properties

- (NSString *)name
{
    return [_dictionary valueForKey:CLUSER_REAL_NAME];
}

- (NSString *)screenName
{
    return [_dictionary valueForKey:CLUSER_SCREEN_NAME];
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

@end
