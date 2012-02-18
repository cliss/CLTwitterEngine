//
//  CLDirectMessage.h
//  Sedge
//
//  Created by Casey Liss on 6/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTwitterEngine.h"

@class CLDirectMessage, CLTwitterUser, CLTweetMedia;

typedef void(^CLDirectMessageHandler)(CLDirectMessage *message, NSError *error);

@interface CLDirectMessage : NSObject
{
    NSDictionary *_dictionary;
    CLTweetMedia *_media;
}

@property (readonly) NSDate *date;
@property (readonly) NSString *dateString;
@property (readonly) CLTwitterUser *sender;
@property (readonly) CLTwitterUser *recipient;
@property (readonly) NSString *text;
@property (readonly) NSString *expandedText;
@property (readonly) CLTweetMedia *media;
@property (readonly) NSNumber *messageId;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)deleteMessageWithErrorHandler:(CLErrorHandler)handler;
+ (void)getDirectMessageWithId:(NSNumber *)messageId completionHandler:(CLDirectMessageHandler)handler;
+ (void)postDirectMessageToScreenName:(NSString *)screenName withBody:(NSString *)body completionHandler:(CLDirectMessageHandler)handler;

@end

