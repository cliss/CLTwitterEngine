//
//  CLTwitterUser.h
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Ironworks Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTwitterUser : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSString *name;
@property (readonly) NSString *screenName;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
