//
//  CLTwitterPhotoSize.h
//  Sedge
//
//  Created by Casey Liss on 17/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTwitterPhotoSize : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSNumber *width;
@property (readonly) NSNumber *height;
@property (readonly) NSString *resizeKind;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
