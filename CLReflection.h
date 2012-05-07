//
//  CLReflection.h
//  Sedge
//
//  Created by Casey Liss on 6/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CLAction)(id item);

@interface CLReflection : NSObject

+ (NSArray *)classesWhichConformToProtocol:(Protocol *)protocol;
+ (void)forClassesConformingToProtocol:(Protocol *)protocol performAction:(CLAction)action;

@end
