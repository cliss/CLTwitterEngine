//
//  CLTwitterUser.h
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTwitterEngine.h"

@class CLTwitterUser;

typedef void(^CLUserHandler)(CLTwitterUser *user, NSError *error);
typedef void(^CLUserCursoredArrayHandler)(NSArray *users, NSNumber *nextBatchCursor, NSError *error);
typedef void(^CLUserArrayHandler)(NSArray *users, NSError *error);

@interface CLTwitterUser : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSString *name;
@property (readonly) NSString *screenName;
@property (readonly) NSString *nameOrScreenName;
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
- (void)getTimelineWithHandler:(CLArrayHandler)handler;
- (void)getFollowersAtCursorPosition:(NSNumber *)cursor completionHandler:(CLUserCursoredArrayHandler)handler;
- (void)getFollowingAtCursorPosition:(NSNumber *)cursor completionHandler:(CLUserCursoredArrayHandler)handler;

+ (void)getCurrentUserWithCompletionHandler:(CLUserHandler)handler;
+ (void)getUserWithScreenName:(NSString *)screenName completionHandler:(CLUserHandler)handler;
+ (void)getUserWithId:(NSNumber *)userId completionHandler:(CLUserHandler)handler;
+ (void)getUsersWithIds:(NSString *)usersCsv completionHandler:(CLUserArrayHandler)handler;

@end
