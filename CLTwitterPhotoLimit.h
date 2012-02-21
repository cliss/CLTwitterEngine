//
//  CLTwitterPhotoLimit.h
//  Sedge
//
//  Created by Casey Liss on 20/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTwitterPhotoLimit : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSNumber *remainingHits;
@property (readonly) NSNumber *resetTimeInSeconds;
@property (readonly) NSDate *resetDate;
@property (readonly) NSNumber *dailyLimit;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
