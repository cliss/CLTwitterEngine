//
//  CLFriendList.h
//  Sedge
//
//  Created by Casey Liss on 13/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTwitterEntity.h"

@interface CLFriendList : NSObject <CLTwitterEntity>
{
    NSArray *_friends;
}

@property (readonly) NSArray *friends;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
