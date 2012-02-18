//
//  CLTwitterConfiguration.h
//  Sedge
//
//  Created by Casey Liss on 17/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLTwitterConfiguration;

typedef void(^CLTwitterConfigurationHandler)(CLTwitterConfiguration *configuration, NSError *error);

@interface CLTwitterConfiguration : NSObject
{
    NSDictionary *_dictionary;
}

@property (readonly) NSNumber *maxMediaPerUpload;
@property (readonly) NSNumber *photoSizeLimit;
@property (readonly) NSNumber *mediaShortUrlLength;
@property (readonly) NSNumber *insecureShortUrlLength;
@property (readonly) NSNumber *secureShortUrlLength;
@property (readonly) NSArray *nonUsernamePaths;
@property (readonly) NSDictionary *photoSizes;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (void)getTwitterConfigurationWithHandler:(CLTwitterConfigurationHandler)handler;

@end
