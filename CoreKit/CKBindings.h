//
//  CKBindings.h
//  CoreKit
//
//  Created by Matt Newberry on 7/21/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecord.h"

typedef enum CKBindingChangeType{
    CKBindingChangeTypeCreated,
    CKBindingChangeTypeUpdated,
    CKBindingChangeTypeDeleted
} CKBindingChangeType;

typedef void (^CKBindingChangeBlock) (NSString *keypath, id object, CKBindingChangeType changeType);

@interface CKRecord (CKBindings)

- (void) bind:(id) object toKeyPath:(NSString *) keypath;
- (void) bindToBlock:(CKBindingChangeBlock) block;
- (void) bindBlock:(CKBindingChangeBlock) block toChangeType:(CKBindingChangeType) changeType;
- (NSArray *) bindingsForObject:(id) object;


@end
