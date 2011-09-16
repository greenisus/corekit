//
//  CKRouter.m
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRouter.h"
#import "CKDefines.h"
#import "CKRequest.h"
#import "CKManager.h"
#import "CKSupport.h"
#import "CKRecord+CKRouter.h"


#define ckRouterCacheFile [[NSBundle bundleForClass:[self class]] pathForResource:@"CKRouterCacheFile" ofType:@"plist"]

@implementation CKRouter

@synthesize routes = _routes;

+ (CKRouter *) sharedRouter{
    
    return [CKManager sharedManager].router;
}

- (id) init{
    
    if(self = [super init]){
        
        _routes = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) mapModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method{
    
    CKRouterMap *map = [CKRouterMap map];
    map.model = model;
    map.remotePath = path;
    map.requestMethod = method;
    
    [self addMap:map];
}

- (void) mapInstancesOfModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method{
    
    CKRouterMap *map = [CKRouterMap map];
    map.model = model;
    map.remotePath = path;
    map.requestMethod = method;
    map.isInstanceMap = YES;
    
    [self addMap:map];
}

- (void) mapRelationship:(NSString *) relationship forModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method{
    
    CKRouterMap *map = [CKRouterMap map];
    map.localAttribute = relationship;
    map.remotePath = path;
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

- (CKRouterMap *) mapForInstancesOfModel:(Class) model forRequestMethod:(CKRequestMethod) method{
    
    NSArray *maps = [self mapsForModel:model];
    __block CKRouterMap *instanceMap = nil;
    
    [maps enumerateObjectsUsingBlock:^(CKRouterMap *map, NSUInteger index, BOOL *stop){
        
        if(map.isInstanceMap == YES && (map.requestMethod == method || map.requestMethod == CKRequestMethodALL)){
            
            instanceMap = map;
            *stop = YES;
        }
    }];
    
    return instanceMap;
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
                return (map.requestMethod == method || map.requestMethod == CKRequestMethodALL);
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
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
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

- (void) mapKeyPathsToAttributes:(Class) model sourceKeyPath:(NSString*)sourceKeyPath, ... {
    
    va_list args;
    va_start(args, sourceKeyPath);
    
    for (NSString* keyPath = sourceKeyPath; keyPath != nil; keyPath = va_arg(args, NSString*)) {
        
		NSString* attributeKeyPath = va_arg(args, NSString*);
        [self mapLocalAttribute:attributeKeyPath toRemoteKey:keyPath forModel:model];
    }
    
    va_end(args);
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


- (NSMutableDictionary *) routes{
    
    return _routes == nil ? [self setupCache] : _routes;
}

- (NSMutableDictionary *) setupCache{
    
    _routes = [[NSMutableDictionary alloc] init];
    
    NSDictionary *entities = [[CKManager sharedManager].coreData.managedObjectModel entitiesByName];
    
    [entities enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSEntityDescription *description, BOOL *stop){
        
        NSMutableArray *maps = [NSMutableArray array];
        Class model = NSClassFromString([description managedObjectClassName]);
        
        for(int x = CKRequestMethodGET; x <= CKRequestMethodHEAD; x++){
                        
            [maps addObject:[model mapForRequestMethod:(CKRequestMethod) x]];
        }
        
        [_routes setObject:maps forKey:key];
    }];
    
    //[_routes writeToFile:ckRouterCacheFile atomically:NO];
    
    return _routes;
}

@end
