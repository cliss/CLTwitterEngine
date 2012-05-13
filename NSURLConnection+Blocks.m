//
//  NSURLConnection+Blocks.m
//  Sedge
//
//  Created by Casey Liss on 5/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "NSURLConnection+Blocks.h"


@interface NSURLConnectionBlockDelegate : NSObject<NSURLConnectionDelegate>
{
    CLDataReceiver _receiver;
    CLConnectionErrorHandler _handler;
}

- (id)initWithDataReceiver:(CLDataReceiver)receiver errorHandler:(CLConnectionErrorHandler)handler;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

@end



@implementation NSURLConnection (Blocks)

- (id)initWithRequest:(NSURLRequest *)request dataReceiver:(CLDataReceiver)receiver erorrHandler:(CLConnectionErrorHandler)errorHandler
{
    NSURLConnectionBlockDelegate *del = [[NSURLConnectionBlockDelegate alloc] initWithDataReceiver:receiver errorHandler:errorHandler];
    if ([self initWithRequest:request delegate:del])
    {
        NSLog(@"Good so far.");
    }
    else 
    {
        NSLog(@"Notsomuch.");
    }
    
    return self;
}

@end







@implementation NSURLConnectionBlockDelegate

- (id)initWithDataReceiver:(CLDataReceiver)receiver errorHandler:(CLConnectionErrorHandler)handler
{
    if (self = [super init])
    {
        _receiver = [receiver copy];
        _handler = [handler copy];
    }
    
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    if ([data length] > 2)
//    {
//        NSLog(@"Did receive %lu bytes of data.", [data length]);
//    }
    //NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"Received: %@", string);
    _receiver(data);
    
}

@end
