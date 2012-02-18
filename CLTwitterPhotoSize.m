//
//  CLTwitterPhotoSize.m
//  Sedge
//
//  Created by Casey Liss on 17/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLTwitterPhotoSize.h"
#import "CLTweetJSONStrings.h"

@implementation CLTwitterPhotoSize

#pragma mark Properties

- (NSNumber *)width
{
    return [_dictionary objectForKey:CLTWITTER_PHOTO_SIZE_WIDTH];
}

- (NSNumber *)height
{
    return [_dictionary objectForKey:CLTWITTER_PHOTO_SIZE_HEIGHT];
}

- (NSString *)resizeKind
{
    return [_dictionary objectForKey:CLTWITTER_PHOTO_SIZE_RESIZE_KIND];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _dictionary = [dictionary copy];
    }
    
    return self;
}

@end
