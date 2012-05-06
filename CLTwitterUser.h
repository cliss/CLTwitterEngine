//
//  CLTwitterUser.h
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTwitterEngine.h"
#import "CLTwitterEntity.h"

@class CLTwitterUser;

typedef void(^CLUserCursoredArrayHandler)(NSArray *users, NSNumber *nextBatchCursor, NSError *error);
typedef void(^CLUserArrayHandler)(NSArray *users, NSError *error);
typedef void(^CLImageHandler)(NSImage *image, NSError *error);
typedef void(^CLUserBlockedHandler)(BOOL isBlocked);


@interface CLTwitterUser : NSObject <CLTwitterEntity>
{
    NSDictionary *_dictionary;
}

@property (readonly) NSString *name;
@property (readonly) NSString *screenName;
@property (readonly) NSString *nameOrScreenName;
@property (readonly) NSString *bio;
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
- (void)getProfileImageForImageSize:(NSString *)imageSize completionHandler:(CLImageHandler)handler;
- (void)getFavoritesPage:(NSNumber *)page withCompletionHandler:(CLArrayHandler)handler;
- (void)postReportSpamWithErrorHandler:(CLErrorHandler)handler;
- (void)blockUserWithErrorHandler:(CLErrorHandler)handler;
- (void)unblockUserWithErrorHandler:(CLErrorHandler)handler;

+ (void)getCurrentUserWithCompletionHandler:(CLUserHandler)handler;
+ (void)getUserWithScreenName:(NSString *)screenName completionHandler:(CLUserHandler)handler;
+ (void)getUserWithId:(NSNumber *)userId completionHandler:(CLUserHandler)handler;
+ (void)getUsersWithIds:(NSArray *)userIds completionHandler:(CLUserArrayHandler)handler;
+ (void)getUsersWithIdsCsv:(NSString *)usersCsv completionHandler:(CLUserArrayHandler)handler;
+ (void)searchForUserWithQuery:(NSString *)query page:(NSNumber *)page resultsHandler:(CLArrayHandler)handler;
+ (void)isUserBlocked:(NSString *)screenName completionHandler:(CLUserBlockedHandler)handler;

@end
