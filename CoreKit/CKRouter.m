//
//  CKRouter.m
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRouter.h"
#import "CKDefines.h"
#import "CKManager.h"

@implementation CKRouter

@synthesize routes = _routes;

+ (CKRouter *) sharedRouter{
    
    return [CKManager sharedManager].router;
}

- (id)init {
    
    if (self = [super init]) {
        
        _routes = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) dealloc{
    
    RELEASE_SAFELY(_routes);
    
    [super dealloc];
}

- (void) mapModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method{
    
    CKRouterMap *map = [CKRouterMap map];
    map.model = model;
    map.path = path;
    map.requestMethod = method;
    
    [self addMap:map];
}

- (void) mapRelationship:(NSString *) relationship forModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method{
    
    CKRouterMap *map = [CKRouterMap map];
    map.localAttribute = relationship;
    map.path = path;
    map.model = model;
    map.requestMethod = method;
    
    [self addMap:map];
}

- (void) mapLocalAttribute:(NSString *) localAttribute toRemoteKey:(NSString *) remoteKey forModel:(Class) model{
    
    CKRouterMap *map = [CKRouterMap map];
    map.localAttribute = localAttribute;
    map.remoteAttribute = remoteKey;
    map.model = model;
    
    [self addMap:map];
}

- (CKRouterMap *) mapForModel:(Class) model forRequestMethod:(CKRequestMethod) method{
    
    return [self mapForRelationship:nil forModel:model andRequestMethod:method];
}

- (CKRouterMap *) mapForRelationship:(NSString *) relationship forModel:(Class) model andRequestMethod:(CKRequestMethod) method{
    
    NSArray *routes = [self mapsForModel:model];
    CKRouterMap *map = nil;
    
    if([routes count] > 0){
        
        NSUInteger index = [routes indexOfObjectPassingTest:^BOOL(CKRouterMap *map, NSUInteger idx, BOOL *stop) {
            
            if(relationship != nil){
                
                if([map.localAttribute isEqualToString:relationship])
                    return map.requestMethod == method;
                else
                    return NO;
            }
            else if(method)
                return map.requestMethod == method;
            else
                return [relationship isEqualToString:map.localAttribute];
        }];
                
        if(index != NSNotFound)
            map = [routes objectAtIndex:index];
    }
        
    return map;
}
    
- (NSArray *) mapsForModel:(Class) model{
    
    return [_routes objectForKey:[model description]];
}

- (NSDictionary *) attributeMapForModel:(Class) model{
    
    __block NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    NSArray *maps = [self mapsForModel:model];
    
    [maps enumerateObjectsUsingBlock:^(CKRouterMap *map, NSUInteger idx, BOOL *stop){
        
        if([map isAttributeMap])
            [attributes setObject:map.remoteAttribute forKey:map.localAttribute];
    }];
    
    return attributes;
}

- (void) addMap:(CKRouterMap *) map{
    
    NSString *className = [map.model description];
    
    if([[_routes allKeys] containsObject:className]){
        
        NSMutableArray *maps = [[_routes objectForKey:className] mutableCopy];
        [maps addObject:map];
        [_routes setObject:maps forKey:className];
        [maps release];
    }
    else{
        
        [_routes setObject:[NSArray arrayWithObject:map] forKey:className];
    }
}

- (NSString *) localAttributeForRemoteKey:(NSString *) remoteAttribute forModel:(Class) model{
    
    NSArray *maps = [self mapsForModel:model];
    __block NSString *attribute = nil;
    
    [maps enumerateObjectsUsingBlock:^(CKRouterMap *map, NSUInteger idx, BOOL *stop){
        
        if([map.remoteAttribute isEqualToString:remoteAttribute])
            attribute = map.localAttribute;
    }];
    
    return attribute;
}

- (NSString *) remoteKeyForLocalAttribute:(NSString *) localAttribute forModel:(Class) model{
    
    NSArray *maps = [self mapsForModel:model];
    __block NSString *attribute = nil;
    
    [maps enumerateObjectsUsingBlock:^(CKRouterMap *map, NSUInteger idx, BOOL *stop){
        
        if([map.localAttribute isEqualToString:localAttribute])
            attribute = map.remoteAttribute;
    }];
    
    return attribute;
}

@end
