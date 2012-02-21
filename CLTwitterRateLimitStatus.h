//
//  CLTwitterRateLimitStatus.h
//  Sedge
//
//  Created by Casey Liss on 20/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLTwitterPhotoLimit;
@class CLTwitterRateLimitStatus;

typedef void(^CLTwitterRateLimitHandler)(CLTwitterRateLimitStatus *limit, NSError *error);

@interface CLTwitterRateLimitStatus : NSObject
{
    NSDictionary *_dictionary;
    CLTwitterPhotoLimit *_photoLimit;
}

@property (readonly) NSNumber *remainingHits;
@property (readonly) NSNumber *resetTimeInSeconds;
@property (readonly) NSNumber *hourlyLimit;
@property (readonly) CLTwitterPhotoLimit *photoLimit;
@property (readonly) NSDate *resetDate;

+ (void)getRateLimitStatusWithCompletionHandler:(CLTwitterRateLimitHandler)handler;

@end
