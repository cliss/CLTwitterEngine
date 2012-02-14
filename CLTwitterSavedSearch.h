//
//  CLTwitterSavedSearch.h
//  Sedge
//
//  Created by Casey Liss on 13/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTwitterEngine.h"

@class CLTwitterSavedSearch;

typedef void(^CLTwitterSavedSearchHandler)(CLTwitterSavedSearch *search, NSError *error);

@interface CLTwitterSavedSearch : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSNumber *searchId;
@property (readonly) NSString *name;
@property (readonly) NSString *query;
@property (readonly) NSDate *date;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)deleteWithErrorHandler:(CLErrorHandler)handler;
+ (void)getSavedSearchTermsWithHandler:(CLArrayHandler)handler;
+ (void)getSavedSearchWithId:(NSNumber *)searchId completionHandler:(CLTwitterSavedSearchHandler)handler;
+ (void)createSavedSearchWithQuery:(NSString *)query completionHandler:(CLTwitterSavedSearchHandler)handler;

@end
