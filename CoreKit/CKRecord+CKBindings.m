//
//  CKRecord+CKBindings.m
//  CoreKit
//
//  Created by Matt Newberry on 8/26/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecord+CKBindings.h"
#import "CKBindings.h"
#import <UIKit/UIKit.h>

@implementation CKRecord (CKBindings)

- (CKBindingMap *) bindTo:(id) object forKeyPath:(NSString *) keyPath forChangeType:(CKBindingChangeType) changeType{
    
    CKBindingMap *map = nil;
        
    if([object isKindOfClass:[UIView class]]){
        
        map = [[CKBindings sharedBindings] bindModel:self toUIObject:object forKeyPath:keyPath];
    }
    else{
        
        map = [[CKBindings sharedBindings] bindModel:self toBlock:object forChangeType:changeType];
    }
    
    return map;
}

- (CKBindingMap *) bindTo:(id) object forKeyPath:(NSString *) keyPath{
    
    return [self bindTo:object forKeyPath:keyPath forChangeType:CKBindingChangeTypeAll];
}

- (CKBindingMap *) bindTo:(id) object{
    
    return [self bindTo:object forKeyPath:nil];
}

- (CKBindingMap *) bindToSelector:(SEL) selector inTarget:(id) target forKeyPath:(NSString *) keyPath forChangeType:(CKBindingChangeType) changeType{
    
    return [[CKBindings sharedBindings] bindModel:self toSelector:selector inTarget:target forChangeType:changeType];
}

+ (CKBindingMap *) bindToSelector:(SEL) selector inTarget:(id) target forChangeType:(CKBindingChangeType) changeType{
    
    return [[CKBindings sharedBindings] bindEntity:[self class] toSelector:selector inTarget:target forChangeType:changeType];
}

+ (CKBindingMap *) bindToBlock:(CKBindingChangeBlock) block forChangeType:(CKBindingChangeType) changeType{
 
    return [[CKBindings sharedBindings] bindEntity:[self class] toBlock:block forChangeType:changeType];
}

@end
