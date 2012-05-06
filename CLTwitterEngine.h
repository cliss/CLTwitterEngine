//
//  CLTwitterEngine.h
//  Sedge
//
//  Created by Casey Liss on 4/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLTwitterUser;

typedef void(^CLErrorHandler)(NSError *error);
typedef id(^CLJSONConverter)(NSData *dataToConvert);
typedef void(^CLConnectionAuthorizer)(NSMutableURLRequest *request);
typedef void(^CLArrayHandler)(NSArray *array, NSError *error);
typedef void(^CLUserHandler)(CLTwitterUser *user, NSError *error);
typedef void(^CLTwitterEntityHandler)(id entity);

@interface CLTwitterEngine : NSObject
{
    NSURLConnection *_streamingConnection;
}

@property (nonatomic, copy) CLJSONConverter converter;
@property (nonatomic, copy) CLConnectionAuthorizer authorizer;
@property (readonly) BOOL isReady;

+ (id)sharedEngine;
+ (id)createTwitterObject:(id)parsedJSON;
- (id)convertJSON:(NSData *)data;
- (void)authorizeRequest:(NSMutableURLRequest *)request;
- (NSArray *)getTweetsFromJSONData:(NSData *)data;
- (void)getTimeLineWithCompletionHandler:(CLArrayHandler)handler;
- (void)getMentionsWithCompletionHandler:(CLArrayHandler)handler;
- (void)getRetweetsOfMeWithCompletionHandler:(CLArrayHandler)handler;
- (void)getRecentDirectMessagesWithCompletionHandler:(CLArrayHandler)handler;
- (void)getPendingFollowRequestsOfMeWithHandler:(CLArrayHandler)handler;
- (void)getMyPendingFollowRequestsWithHandler:(CLArrayHandler)handler;
- (void)getMyFavoritesPage:(NSNumber *)page withCompletionHandler:(CLArrayHandler)handler;
- (void)getBlockedUsersWithCompletionHandler:(CLArrayHandler)handler;
- (void)followUserWithScreenName:(NSString *)screenName handler:(CLUserHandler)handler;
- (void)stopFollowingUserWithScreenName:(NSString *)screenName errorHandler:(CLErrorHandler)handler;
- (void)updateProfileWithName:(NSString *)name 
                          url:(NSURL *)url 
                     location:(NSString *)location 
                  description:(NSString *)description
            completionHandler:(CLUserHandler)handler;
- (void)updateProfileImage:(NSImage *)image withErrorHandler:(CLErrorHandler)handler;
- (void)startStreamingWithTweetHandler:(CLTwitterEntityHandler)handler;

@end
