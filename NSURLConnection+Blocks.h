//
//  NSURLConnection+Blocks.h
//  Sedge
//
//  Created by Casey Liss on 5/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CLDataReceiver)(NSData *data);
typedef void(^CLConnectionErrorHandler)(NSError *error);

@interface NSURLConnection (Blocks)

- (id)initWithRequest:(NSURLRequest *)request 
                        dataReceiver:(CLDataReceiver)receiver
                        erorrHandler:(CLConnectionErrorHandler)errorHandler;

@end
