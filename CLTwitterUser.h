//
//  CLTwitterUser.h
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLTwitterUser;

typedef void(^CLUserHandler)(CLTwitterUser *user, NSError *error);
typedef void(^CLUserArrayHandler)(NSArray *users, NSNumber *nextBatchCursor, NSError *error);

@interface CLTwitterUser : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSString *name;
@property (readonly) NSString *screenName;
@property (readonly) NSURL *profileImageURL;
@property (readonly) NSImage *profileImage;
@property (readonly) BOOL isVerified;
@property (readonly) NSString *location;
@property (readonly) NSURL *profileUrl;
@property (readonly) NSURL *personalUrl;
@property (readonly) NSNumber *tweetCount;
@property (readonly) NSNumber *listedCount;
@property (readonly) NSNumber *followingCount;
@property (readonly) NSNumber *followerCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)getFollowersAtCursorPosition:(NSNumber *)cursor completionHandler:(CLUserArrayHandler)handler;
- (void)getFollowingAtCursorPosition:(NSNumber *)cursor completionHandler:(CLUserArrayHandler)handler;

+ (void)getUserWithScreenName:(NSString *)screenName completionHandler:(CLUserHandler)handler;
+ (void)getUserWithId:(NSNumber *)userId completionHandler:(CLUserHandler)handler;

@end
