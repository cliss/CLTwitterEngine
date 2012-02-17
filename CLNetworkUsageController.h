//
//  CLNetworkUsageController.h
//  Sedge
//
//  Created by Casey Liss on 17/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CLNetworkUsageControllerCallback)(BOOL networkIsInUse);

@interface CLNetworkUsageController : NSObject
{
    uint _refCount;
    CLNetworkUsageControllerCallback _callback;
}

@property (copy) CLNetworkUsageControllerCallback callback;

+ (CLNetworkUsageController *)sharedController;
- (void)beginNetworkRequest;
- (void)endNetworkRequest;

@end
