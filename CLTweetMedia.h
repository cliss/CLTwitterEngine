//
//  CLTweetMedia.h
//  Sedge
//
//  Created by Casey Liss on 4/2/12.
//  Copyright (c) 2012 Ironworks Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLTweet;

@interface CLTweetMedia : NSObject
{
    NSDictionary *_dictionary;
    __weak CLTweet *_parent;
}

@property (nonatomic, readonly) NSArray *hashTags;
@property (nonatomic, readonly) NSArray *urls;
@property (nonatomic, readonly) BOOL hasUrls;
@property (nonatomic, readonly) NSArray *mentions;
@property (nonatomic, weak) CLTweet *parent;

- (id)initWithParent:(CLTweet *)tweet data:(NSDictionary *)data;
- (NSString *)expandUrlsInParent;

@end
