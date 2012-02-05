//
//  CLTwitterEngine.h
//  Sedge
//
//  Created by Casey Liss on 4/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^CLJSONConverter)(NSData *dataToConvert);
typedef void(^CLConnectionAuthorizer)(NSMutableURLRequest *request);
typedef void(^CLArrayHandler)(NSArray *array, NSError *error);

@interface CLTwitterEngine : NSObject
{
    
}

@property (nonatomic, copy) CLJSONConverter converter;
@property (nonatomic, copy) CLConnectionAuthorizer authorizer;

+ (id)sharedEngine;
- (id)convertJSON:(NSData *)data;
- (void)authorizeRequest:(NSMutableURLRequest *)request;
- (void)getTimeLineWithCompletionHandler:(CLArrayHandler)handler;

@end
