//
//  CLTwitterSearch.h
//  Sedge
//
//  Created by Casey Liss on 15/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLTwitterSearch;

typedef void(^CLSearchResultsHandler)(CLTwitterSearch *searchResult, NSError *error);

@interface CLTwitterSearch : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSArray *results;
@property (readonly) BOOL olderTweetsAvailable;

+ (void)beginSearchWithQuery:(NSString *)query completionHandler:(CLSearchResultsHandler)handler;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)getOlderSearchResultsWithCompletionHandler:(CLSearchResultsHandler)handler;
- (void)getNewerSearchResultsWithCompletionHandler:(CLSearchResultsHandler)handler;

@end
