//
//  CLTwitterEntity.h
//  Sedge
//
//  Created by Casey Liss on 5/5/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLTwitterEntity <NSObject>

+ (BOOL)isThisEntity:(id)parsedJSON;

@end
