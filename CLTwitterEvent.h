//
//  CLTwitterEvent.h
//  Sedge
//
//  Created by Casey Liss on 5/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTwitterEntity.h"

typedef enum {
    CLTwitterEventTypeUnknown = -99,
    
    CLTwitterEventTypeUnfavorite = -1,
    CLTwitterEventTypeFavorite = 1,
    
    CLTwitterEventTypeBlock = 2,
    CLTwitterEventTypeFriend = 3,
    CLTwitterEventTypeRetweet = 4,
    CLTwitterEventTypeList = 5,
    CLTwitterEventTypeProfile = 6
} CLTwitterEventType;

@interface CLTwitterEvent : NSObject <CLTwitterEntity>
{
    NSDictionary *_dictionary;
}

@property (readonly) id target;
@property (readonly) id source;
@property (readonly) CLTwitterEventType eventType;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
