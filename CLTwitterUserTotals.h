//
//  CLTwitterUserTotals.h
//  Sedge
//
//  Created by Casey Liss on 23/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLTwitterUserTotals;

typedef void(^CLTwitterUserTotalsHandler)(CLTwitterUserTotals *totals, NSError *error);

@interface CLTwitterUserTotals : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSNumber *following;
@property (readonly) NSNumber *followers;
@property (readonly) NSNumber *tweets;
@property (readonly) NSNumber *favorites;

+ (void)getUserTotalsWithCompletionHandler:(CLTwitterUserTotalsHandler)handler;

@end
