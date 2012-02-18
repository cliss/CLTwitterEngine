//
//  CLNetworkUsageController.m
//  Sedge
//
//  Created by Casey Liss on 17/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import "CLNetworkUsageController.h"

@interface CLNetworkUsageController ()
- (id)init;
@end

@implementation CLNetworkUsageController

@synthesize callback;

#pragma mark -
#pragma mark Initialization

- (id)init
{
    if (self = [super init])
    {
        _refCount = 0;
    }
    
    return self;
}

#pragma mark -
#pragma mark Class Methods

+ (CLNetworkUsageController *)sharedController
{
    static dispatch_once_t dispatch;
    static CLNetworkUsageController *controller;
    dispatch_once(&dispatch, ^{ controller = [[self alloc] init]; });
    
    return controller;
}

#pragma mark -
#pragma mark Instance Methods

- (void)beginNetworkRequest
{
    if (!_refCount)
    {
        if (callback)
        {
            callback(YES);
        }
    }
    ++_refCount;
}

- (void)endNetworkRequest
{
    // Don't go below zero.
    if (_refCount)
    {
        --_refCount;
        if (!_refCount && callback)
        {
            callback(NO);
        }
    }
}

@end
