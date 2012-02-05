//
//  CLTwitterUser.m
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Ironworks Consulting. All rights reserved.
//

#import "CLTwitterUser.h"

@implementation CLTwitterUser

- (NSString *)name
{
    return [_dictionary valueForKey:@"name"];
}

- (NSString *)screenName
{
    return [_dictionary valueForKey:@"screen_name"];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _dictionary = dictionary;
    }
    
    return self;
}

@end
