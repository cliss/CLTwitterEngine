//
//  CLTwitterList.h
//  Sedge
//
//  Created by Casey Liss on 2/3/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTwitterEngine.h"

@class CLTwitterUser;
@class CLTwitterList;

typedef void(^CLTwitterListHandler)(CLTwitterList *list, NSError *error);
typedef void(^CLCursoredArrayHandler)(NSNumber *previousCursor, NSNumber *nextCursor, NSArray *array, NSError *error);

@interface CLTwitterList : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSString *slug;
@property (readonly) NSString *name;
@property (readonly) NSString *url;
@property (readonly) NSNumber *subscribers;
@property (readonly) NSNumber *members;
@property (readonly) NSNumber *listId;
@property (readonly) NSString *mode;
@property (readonly) NSString *fullname;
@property (readonly) NSString *desc;
@property (readonly) CLTwitterUser *user;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)getTimelineOnPage:(NSUInteger)page tweetsPerPage:(NSUInteger)pageLength completionHandler:(CLArrayHandler)handler;
- (void)getListMembersWithCompletionHandler:(CLArrayHandler)handler;
- (void)subscribeWithErrorHandler:(CLErrorHandler)handler;
- (void)unsubscribeWithErrorHandler:(CLErrorHandler)handler;
- (void)getSubscribersWithCompletionHandler:(CLArrayHandler)handler;
- (void)updateListWithName:(NSString *)name 
               description:(NSString *)description 
                 isPrivate:(BOOL)privacyOn 
              errorHandler:(CLErrorHandler)handler;
- (void)addMember:(NSString *)screenName errorHandler:(CLErrorHandler)handler;
- (void)removeMember:(NSString *)screenName errorHandler:(CLErrorHandler)handler;
- (void)deleteListWithErrorHandler:(CLErrorHandler)handler;

+ (void)getAllListsWithCompletionHandler:(CLArrayHandler)handler;
+ (void)getListsForUser:(NSString *)userName withCompletionHandler:(CLArrayHandler)handler;
+ (void)getListWithId:(NSNumber *)listId completionHandler:(CLTwitterListHandler)handler;
+ (void)createListWithName:(NSString *)name 
               description:(NSString *)description 
                 isPrivate:(BOOL)privacyOn 
         completionHandler:(CLTwitterListHandler)handler;
+ (void)getUsersListSubscriptionsForUser:(NSString *)screenName 
                                  cursor:(NSNumber *)cursor 
                            countPerPage:(NSNumber *)count
                       completionHandler:(CLCursoredArrayHandler)handler;

@end
