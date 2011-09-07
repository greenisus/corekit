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

- (CKBindingMap *) bindTo:(id) object forKeyPath:(NSString *) keyPath forChangeType:(CKBindingChangeType) changeType;

- (CKBindingMap *) bindTo:(id) object forKeyPath:(NSString *) keyPath;

- (CKBindingMap *) bindTo:(id) object;

- (CKBindingMap *) bindToSelector:(SEL) selector inTarget:(id) target forKeyPath:(NSString *) keyPath forChangeType:(CKBindingChangeType) changeType;

+ (CKBindingMap *) bindToSelector:(SEL) selector inTarget:(id) target forChangeType:(CKBindingChangeType) changeType;

+ (CKBindingMap *) bindToBlock:(CKBindingChangeBlock) block forChangeType:(CKBindingChangeType) changeType;

@end
