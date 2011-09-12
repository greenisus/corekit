//
//  CKBindings.h
//  CoreKit
//
//  Created by Matt Newberry on 7/21/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecord.h"
@class CKBindingMap;

typedef enum CKBindingChangeType{
    CKBindingChangeTypeInserted,
    CKBindingChangeTypeUpdated,
    CKBindingChangeTypeDeleted,
    CKBindingChangeTypeAll
} CKBindingChangeType;

typedef void (^CKBindingChangeBlock) (void);

@interface CKBindings : NSObject{
    
    NSMutableDictionary *_bindings;
    
@private
    NSMutableSet *_firedMaps;
}

@property (nonatomic, strong) NSMutableDictionary *bindings;
@property (nonatomic, strong) NSMutableSet *firedMaps;

+ (CKBindings *) sharedBindings;

- (CKBindingMap *) bindModel:(NSManagedObject *) model toUIObject:(id) control forKeyPath:(NSString *) keypath;

- (CKBindingMap *) bindModel:(NSManagedObject *) model toSelector:(SEL) selector inTarget:(id) target forChangeType:(CKBindingChangeType) changeType;

- (CKBindingMap *) bindModel:(NSManagedObject *) model toBlock:(CKBindingChangeBlock) block forChangeType:(CKBindingChangeType) changeType;

- (CKBindingMap *) bindEntity:(Class) entity toSelector:(SEL) selector inTarget:(id) target forChangeType:(CKBindingChangeType) changeType;

- (CKBindingMap *) bindEntity:(Class) entity toBlock:(CKBindingChangeBlock) block forChangeType:(CKBindingChangeType) changeType;

- (NSArray *) bindingsForTarget:(id) target forChangeType:(CKBindingChangeType) changeType;
- (NSArray *) bindingsForModel:(NSManagedObject *) model forChangeType:(CKBindingChangeType) changeType;
- (NSArray *) bindingsForEntity:(Class) entity forChangeType:(CKBindingChangeType) changeType;
- (NSArray *) bindingsForChangeType:(CKBindingChangeType) changeType;

- (void) addMap: (CKBindingMap *) map;
- (void) handleChangesForObjects:(NSSet *) objects ofChangeType:(CKBindingChangeType) changeType;

@end
