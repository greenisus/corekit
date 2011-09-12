//
//  CKRouter.h
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRequest.h"
#import "CKRouterMap.h"

@interface CKRouter : NSObject{
    
    NSMutableDictionary *_routes;
}

/** Routing dictionary for classes 
 @param routes Keys represent class names, values represent their route
 */
@property (nonatomic, strong) NSMutableDictionary *routes;

+ (CKRouter *) sharedRouter;

- (void) addMap:(CKRouterMap *) map;

- (void) mapModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method;
- (void) mapInstancesOfModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method;

- (void) mapRelationship:(NSString *) relationship forModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method;

- (void) mapLocalAttribute:(NSString *) localAttribute toRemoteKey:(NSString *) remoteKey forModel:(Class) model;
- (void) mapKeyPathsToAttributes:(Class) model sourceKeyPath:(NSString*)sourceKeyPath, ... NS_REQUIRES_NIL_TERMINATION;

- (CKRouterMap *) mapForModel:(Class) model forRequestMethod:(CKRequestMethod) method;
- (CKRouterMap *) mapForInstancesOfModel:(Class) model forRequestMethod:(CKRequestMethod) method;
- (CKRouterMap *) mapForRelationship:(NSString *) relationship forModel:(Class) model andRequestMethod:(CKRequestMethod) method; 

- (NSDictionary *) attributeMapForModel:(Class) model;
- (NSArray *) mapsForModel:(Class) model;

- (NSString *) localAttributeForRemoteKey:(NSString *) remoteKey forModel:(Class) model;
- (NSString *) remoteKeyForLocalAttribute:(NSString *) localAttribute forModel:(Class) model;

- (NSMutableDictionary *) setupCache;

@end
