//
//  CKBindingMap.h
//  CoreKit
//
//  Created by Matt Newberry on 8/26/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKBindings.h"

@interface CKBindingMap : NSObject{
    
    NSManagedObjectID *_objectID;
    Class _entityClass;
    id _control;
    id _target;
    CKBindingChangeType _changeType;
    CKBindingChangeBlock _block;
    SEL _selector;
    NSString *_keyPath;
}

@property (nonatomic, strong) NSManagedObjectID *objectID;
@property (nonatomic, assign) Class entityClass;
@property (nonatomic, strong) id control;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) CKBindingChangeType changeType;
@property (nonatomic, copy) CKBindingChangeBlock block;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSString *keyPath;

+ (CKBindingMap *) map;
- (void) fire;
- (void) updateControl;
- (CKRecord *) object;

@end
