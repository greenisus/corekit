//
//  CKRecord+CKBindings.h
//  CoreKit
//
//  Created by Matt Newberry on 8/26/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecord.h"
#import "CKBindingMap.h"

@interface CKRecord (CKBindings)

- (CKBindingMap *) bindToUIObject:(id) control forKeyPath:(NSString *) keypath;

- (CKBindingMap *) bindToSelector:(SEL) selector inTarget:(id) target forChangeType:(CKBindingChangeType) changeType;

- (CKBindingMap *) bindToBlock:(CKBindingChangeBlock) block forChangeType:(CKBindingChangeType) changeType;

+ (CKBindingMap *) bindToSelector:(SEL) selector inTarget:(id) target forChangeType:(CKBindingChangeType) changeType;

+ (CKBindingMap *) bindToBlock:(CKBindingChangeBlock) block forChangeType:(CKBindingChangeType) changeType;

@end
