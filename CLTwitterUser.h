//
//  CLTwitterUser.h
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTwitterUser : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSString *name;
@property (readonly) NSString *screenName;
@property (readonly) NSURL *profileImageURL;
@property (readonly) NSImage *profileImage;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
