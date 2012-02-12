//
//  CLTweetMarker.h
//  Sedge
//
//  Created by Casey Liss on 12/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CLTweetMarkerSaveHandler)(BOOL success, NSError *error);
typedef void(^CLTweetMarkerGetHandler)(NSNumber *tweetId, NSError *error);

@interface CLTweetMarker : NSObject

+ (void)markLastReadAsTweet:(NSNumber *)tweetId
                forUsername:(NSString *)user
               inCollection:(NSString *)collection 
                 withApiKey:(NSString *)key
          completionHandler:(CLTweetMarkerSaveHandler)handler;

+ (void)getLastReadForUsername:(NSString *)user 
                  inCollection:(NSString *)collection 
                    withApiKey:(NSString *)key
             completionHandler:(CLTweetMarkerGetHandler)handler;

@end
