//
//  CKRouter+CKRecord.h
//  CoreKit
//
//  Created by Matt Newberry on 8/1/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRouter.h"

@interface CKRouter (CKRouter_CKRecord)

- (void) mapRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method;
- (void) mapRelationship:(NSString *) relationship toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method;
- (void) mapLocalAttribute:(NSString *) localAttribute toRemoteKey:(NSString *) remoteKey;

- (NSDictionary *) attributeMap;

- (NSString *) localAttributeForRemoteKey:(NSString *) remoteKey;
- (NSString *) remoteKeyForLocalAttribute:(NSString *) localAttribute;

@end
