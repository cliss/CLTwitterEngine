//
//  CLTwitterEngine.h
//  Sedge
//
//  Created by Casey Liss on 4/2/12.
//  Copyright (c) 2012 Ironworks Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^JSONConverter)(NSData *dataToConvert);
typedef void(^connectionAuthorizer)(NSMutableURLRequest *request);
typedef void(^arrayHandler)(NSArray *array, NSError *error);

@interface CLTwitterEngine : NSObject
{
    
}

@property (nonatomic, copy) JSONConverter converter;
@property (nonatomic, copy) connectionAuthorizer authorizer;

+ (id)sharedEngine;
- (id)convertJSON:(NSData *)data;
- (void)authorizeRequest:(NSMutableURLRequest *)request;
- (void)getTimeLineWithCompletionHandler:(arrayHandler)handler;

@end
