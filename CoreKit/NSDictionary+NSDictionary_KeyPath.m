//
//  NSDictionary+NSDictionary_KeyPath.m
//  CoreKit
//
//  Created by Matt Newberry on 8/17/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "NSDictionary+NSDictionary_KeyPath.h"

@implementation NSDictionary (NSDictionary_KeyPath)

- (id) objectForKeyPath:(NSString *) keyPath{
    
	NSArray *components = [keyPath componentsSeparatedByString:@"."];
    __block id object = self;
    
    [components enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop){
        
        if([object isKindOfClass:[NSDictionary class]] && [[object allKeys] containsObject:key])
            object = [self valueForKey:key];
        
    }];
    
    return object;
}


@end
