//
//  CKRouter+CKRecord.h
//  CoreKit
//
//  Created by Matt Newberry on 8/1/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecord.h"
#import "CKRouter.h"
#import "CKRouterMap.h"

@interface CKRecord (CKRouter_CKRecord)

+ (void) mapToRemotePath:(NSString *) path;
+ (void) mapToRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method;

+ (void) mapInstancesToRemotePath:(NSString *) path;
+ (void) mapInstancesToRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method;

+ (void) mapRelationship:(NSString *) relationship toRemotePath:(NSString *) path;
+ (void) mapRelationship:(NSString *) relationship toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method;

+ (void) mapAttribute:(NSString *) attribute toRemoteKey:(NSString *) remoteKey;

+ (NSDictionary *) attributeMap;

+ (NSString *) attributeForRemoteKey:(NSString *) remoteKey;
+ (NSString *) remoteKeyForAttribute:(NSString *) attribute;

+ (CKRouterMap *) mapForRequestMethod:(CKRequestMethod) method;
- (CKRouterMap *) mapForRequestMethod:(CKRequestMethod) method;

- (CKRouterMap *) mapForRelationship:(NSString *) relationship;
- (CKRouterMap *) mapForRelationship:(NSString *) relationship forRequestMethod:(CKRequestMethod) method;

@end
