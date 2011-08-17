//
//  NSDictionary+NSDictionary_KeyPath.h
//  CoreKit
//
//  Created by Matt Newberry on 8/17/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionary_KeyPath)

- (id)objectForKeyPath:(NSString *) keyPath;

@end
