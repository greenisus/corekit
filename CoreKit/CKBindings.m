//
//  CKBindings.m
//  CoreKit
//
//  Created by Matt Newberry on 7/21/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKBindings.h"
#import "CKDefines.h"
#import "CKManager.h"
#import "CKBindingMap.h"

@implementation CKBindings

@synthesize bindings = _bindings;
@synthesize firedMaps = _firedMaps;

- (id) init{
    
    if(self = [super init]){
        
        _bindings = [[NSMutableDictionary alloc] init];
        _firedMaps = [[NSMutableSet alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    }
    
    return self;
}

+ (CKBindings *) sharedBindings{
    
    return [CKManager sharedManager].bindings;
}

- (CKBindingMap *) bindModel:(NSManagedObject *) model toUIObject:(id) control forKeyPath:(NSString *) keypath{
    
    CKBindingMap *map = [CKBindingMap map];
    map.objectID = [model objectID];
    map.control = control;
    map.keyPath = keypath;
    map.changeType = CKBindingChangeTypeUpdated;
    
    [self addMap:map];
    
    return map;
}

- (CKBindingMap *) bindModel:(NSManagedObject *)model toBlock:(CKBindingChangeBlock)block forChangeType:(CKBindingChangeType)changeType{
    
    CKBindingMap *map = [CKBindingMap map];
    map.block = block;
    map.objectID = [model objectID];
    map.changeType = changeType;
        
    [self addMap:map];
    
    return map;
}

- (CKBindingMap *) bindModel:(NSManagedObject *) model toSelector:(SEL) selector inTarget:(id) target forChangeType:(CKBindingChangeType) changeType{
    
    CKBindingMap *map = [CKBindingMap map];
    map.objectID = [model objectID];
    map.target = target;
    map.selector = selector;
    map.changeType = changeType;
    
    [self addMap:map];
    
    return map;
}

- (CKBindingMap *) bindEntity:(Class) entity toSelector:(SEL) selector inTarget:(id) target forChangeType:(CKBindingChangeType) changeType{
    
    CKBindingMap *map = [CKBindingMap map];
    map.entityClass = entity;
    map.selector = selector;
    map.target = target;
    map.changeType = changeType;
    
    [self addMap:map];
    
    return map;
}

- (CKBindingMap *) bindEntity:(Class) entity toBlock:(CKBindingChangeBlock) block forChangeType:(CKBindingChangeType) changeType{
    
    CKBindingMap *map = [CKBindingMap map];
    map.entityClass = entity;
    map.block = block;
    map.changeType = changeType;
    
    [self addMap:map];
    
    return map;
}

- (void) addMap: (CKBindingMap *) map{
    
    if(map.entityClass == nil)
        return;
    
    NSString *className = [map.entityClass description];
    
    if([[_bindings allKeys] containsObject:className]){
        
        NSMutableArray *maps = [[_bindings objectForKey:className] mutableCopy];
        
        [maps addObject:map];
        [_bindings setObject:maps forKey:className];
    }
    else{
        
        [_bindings setObject:[NSArray arrayWithObject:map] forKey:className];
    }
}

- (NSArray *) bindingsForTarget:(id) target forChangeType:(CKBindingChangeType) changeType{
    
    NSMutableArray *targetBindings = [NSMutableArray array];
    
    [[_bindings allValues] enumerateObjectsUsingBlock:^(NSArray *maps, NSUInteger idx, BOOL *stop){
       
        [maps enumerateObjectsUsingBlock:^(CKBindingMap *map, NSUInteger idx, BOOL *stop){
            
            if([map.target isEqual:target]){
                
                [targetBindings addObject:map];   
            }
        }];
    }];
    
    return targetBindings;
}

- (NSArray *) bindingsForModel:(NSManagedObject *)model forChangeType:(CKBindingChangeType) changeType{
    
    NSMutableArray *modelBindings = [_bindings objectForKey:[[model class] description]];
    
     if(modelBindings != nil){
         
         [modelBindings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
             
             CKBindingMap *map = (CKBindingMap *) obj;
             if([map.objectID isEqual:[model objectID]] && (changeType == CKBindingChangeTypeAll || changeType == map.changeType)){
                 
                [modelBindings addObject:map];
             }
        }];
     }
     else {
         modelBindings = [NSArray array];
     }
           
    return modelBindings;
}

- (NSArray *) bindingsForEntity:(Class) entity forChangeType:(CKBindingChangeType) changeType{
    
    NSMutableArray *entityBindings = [_bindings objectForKey:[entity description]];
    
    if(entityBindings != nil){
        
        [entityBindings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            CKBindingMap *map = (CKBindingMap *) obj;
            if([map.entityClass isEqual:entity] && (changeType == CKBindingChangeTypeAll || changeType == map.changeType)){
                
                [entityBindings addObject:map];
            }
        }];
    }
    else {
        entityBindings = [NSArray array];
    }
    
    return entityBindings;
}

- (NSArray *) bindingsForChangeType:(CKBindingChangeType)changeType{
    
    NSMutableArray *changeTypeBindings = [NSMutableArray array];
    
    [[_bindings allValues] enumerateObjectsUsingBlock:^(NSArray *maps, NSUInteger idx, BOOL *stop){
        
        [maps enumerateObjectsUsingBlock:^(CKBindingMap *map, NSUInteger idx, BOOL *stop){
                        
            if(changeType == map.changeType || map.changeType == CKBindingChangeTypeAll){
                
                [changeTypeBindings addObject:map];   
            }
        }];
    }];
    
    return changeTypeBindings;
}

- (void) handleChangeNotification:(NSNotification *) notification{
        
    [self handleChangesForObjects:[[notification userInfo] objectForKey:NSInsertedObjectsKey] ofChangeType:CKBindingChangeTypeInserted];
    [self handleChangesForObjects:[[notification userInfo] objectForKey:NSUpdatedObjectsKey] ofChangeType:CKBindingChangeTypeUpdated];
    [self handleChangesForObjects:[[notification userInfo] objectForKey:NSDeletedObjectsKey] ofChangeType:CKBindingChangeTypeDeleted];
    
    [_firedMaps removeAllObjects];
}

- (void) handleChangesForObjects:(NSSet *) objects ofChangeType:(CKBindingChangeType) changeType{

    if(objects != nil && [objects count] > 0){
        
        NSArray *changeTypeBindings = [self bindingsForChangeType:changeType];
        
        NSMutableSet *remainingObjects = [NSMutableSet setWithSet:objects];
        [remainingObjects minusSet:_firedMaps];
        
        [changeTypeBindings enumerateObjectsWithOptions:0 usingBlock:^(CKBindingMap *map, NSUInteger idx, BOOL *stop){
            
            [remainingObjects enumerateObjectsUsingBlock:^(NSManagedObject *object, BOOL *stop){
                
                if([[object.entity managedObjectClassName] isEqualToString:NSStringFromClass(map.entityClass)] && (map.objectID != nil || [map.objectID isEqual:[object objectID]])){
                    
                    [map fire];
                    [_firedMaps addObject:map];
                }
            }];
        }];
    }
}


@end
