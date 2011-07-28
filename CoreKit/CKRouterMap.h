//
//  CKRouterMap.h
//  CoreKit
//
//  Created by Matt Newberry on 7/28/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRequest.h"

@interface CKRouterMap : NSObject{
    
    Class _model;
    NSString *_path;
    NSString *_localAttribute;
    NSString *_remoteAttribute;
    CKRequestMethod _requestMethod;
    
    // Implement callback blocks
}

@property (nonatomic, assign) Class model;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *localAttribute;
@property (nonatomic, retain) NSString *remoteAttribute;
@property (nonatomic, assign) CKRequestMethod requestMethod;

+ (CKRouterMap *) map;

- (BOOL) isAttributeMap;
- (BOOL) isRelationshipMap;
- (BOOL) isRemotePathMap;

@end
