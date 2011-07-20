//
//  CKNSJSONSerialization.m
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKNSJSONSerialization.h"

@implementation CKNSJSONSerialization

- (id) deserialize:(NSData *) data{
    
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if(error)
        NSLog(@"%@", [error localizedFailureReason]);
    
    return value;
}

- (NSData *) serialize:(id) object{
    
    NSData *value = nil;
    
    if([NSJSONSerialization isValidJSONObject:object]){
        
        NSError *error = nil;
        value = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
        
        if(error)
            NSLog(@"%@", [error localizedFailureReason]);
    }
    
    return value;
}

@end
