//
//  CKRecord+CKBindings.m
//  CoreKit
//
//  Created by Matt Newberry on 8/26/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecord+CKBindings.h"
#import "CKBindings.h"

@implementation CKRecord (CKBindings)

- (CKBindingMap *) bindToControl:(id) control forKeyPath:(NSString *) keypath{
    
    return [[CKBindings sharedBindings] bindModel:self toControl:control inTarget:nil forKeyPath:keypath];
}

- (CKBindingMap *) bindToSelector:(SEL) selector inTarget:(id) target forChangeType:(CKBindingChangeType) changeType{
    
    return [[CKBindings sharedBindings] bindModel:self toSelector:selector inTarget:target forChangeType:changeType];
}

- (CKBindingMap *) bindToBlock:(CKBindingChangeBlock) block forChangeType:(CKBindingChangeType) changeType{
    
    return [[CKBindings sharedBindings] bindModel:self toBlock:block forChangeType:changeType];
}

+ (CKBindingMap *) bindToSelector:(SEL) selector inTarget:(id) target forChangeType:(CKBindingChangeType) changeType{
    
    return [[CKBindings sharedBindings] bindEntity:[self class] toSelector:selector inTarget:target forChangeType:changeType];
}

+ (CKBindingMap *) bindToBlock:(CKBindingChangeBlock) block forChangeType:(CKBindingChangeType) changeType{
 
    return [[CKBindings sharedBindings] bindEntity:[self class] toBlock:block forChangeType:changeType];
}

@end
