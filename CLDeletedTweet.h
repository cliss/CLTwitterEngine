//
//  CLDeletedTweet.h
//  Sedge
//
//  Created by Casey Liss on 13/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTwitterEntity.h"

@class CLTweet, CLTwitterUser;

@interface CLDeletedTweet : NSObject <CLTwitterEntity>
{
    NSNumber *_tweetId;
    NSNumber *_userId;
}

@property (readonly) NSNumber *tweetId;
@property (readonly) NSNumber *userId;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
