//
//  NSDictionary+UrlEncoding.h
//  Sedge
//
//  Created by Casey Liss on 3/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

// Cribbed from: http://stackoverflow.com/questions/718429/creating-url-query-parameters-from-nsdictionary-objects-in-objectivec

#import <Foundation/Foundation.h>

@interface NSDictionary (UrlEncoding)

-(NSString*) urlEncodedString;

@end
