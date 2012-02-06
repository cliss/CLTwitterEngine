//
//  CLTweetMedia.h
//  Sedge
//
//  Created by Casey Liss on 4/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLTweet;

@interface CLTweetMedia : NSObject
{
    NSDictionary *_dictionary;
    NSString *_text;
}

@property (nonatomic, readonly) NSArray *hashTags;
@property (nonatomic, readonly) NSArray *urls;
@property (nonatomic, readonly) BOOL hasUrls;
@property (nonatomic, readonly) NSArray *mentions;

- (id)initWithParentText:(NSString *)text mediaData:(NSDictionary *)data;
- (NSString *)textWithURLsExpanded;

@end
