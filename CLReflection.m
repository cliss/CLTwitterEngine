//
//  CLReflection.m
//  Sedge
//
//  Created by Casey Liss on 6/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <objc/objc-runtime.h>
#import "CLReflection.h"

@implementation CLReflection

+ (NSArray *)classesWhichConformToProtocol:(Protocol *)protocol
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    Class *classes = NULL;
    // Figure out how many classes we have
    int numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0)
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        
        // Parse each class
        for (int i = 0; i < numClasses; ++i)
        {
            Class c = classes[i];
            
            if (class_conformsToProtocol(c, protocol))
            {
                [retVal addObject:c];
            }
        }
        
        free(classes);
    }
    
    return retVal;
}

+ (void)forClassesConformingToProtocol:(Protocol *)protocol performAction:(CLAction)action
{
    NSArray *classes = [CLReflection classesWhichConformToProtocol:protocol];
    for (id c in classes)
    {
        Class class = (Class)c;
        action(class);
    }
}

@end
