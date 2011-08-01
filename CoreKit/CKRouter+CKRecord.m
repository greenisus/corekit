//
//  CKRouter+CKRecord.m
//  CoreKit
//
//  Created by Matt Newberry on 8/1/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRouter+CKRecord.h"

@implementation CKRouter (CKRouter_CKRecord)

- (void) mapRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method{
    
    [[CKRouter sharedRouter] mapModel:[self class] toRemotePath:path forRequestMethod:method];
}

- (void) mapRelationship:(NSString *) relationship toRemotePath:(NSString *) path forRequestMethod:(CKRequestMethod) method{
    
    [[CKRouter sharedRouter] mapRelationship:relationship forModel:[self class] toRemotePath:path forRequestMethod:method];
}

- (void) mapLocalAttribute:(NSString *) localAttribute toRemoteKey:(NSString *) remoteKey{
    
    [[CKRouter sharedRouter] mapLocalAttribute:localAttribute toRemoteKey:remoteKey forModel:[self class]];
}

- (NSDictionary *) attributeMap{
    
    return [[CKRouter sharedRouter] attributeMapForModel:[self class]];
}

- (NSString *) localAttributeForRemoteKey:(NSString *) remoteKey{
    
    return [[CKRouter sharedRouter] localAttributeForRemoteKey:remoteKey forModel:[self class]];
}

- (NSString *) remoteKeyForLocalAttribute:(NSString *) localAttribute{
    
    return [[CKRouter sharedRouter] remoteKeyForLocalAttribute:localAttribute forModel:[self class]];
}

@end
