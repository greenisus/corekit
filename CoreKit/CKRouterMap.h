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
    id _object;
    NSString *_remotePath;
    NSString *_localAttribute;
    NSString *_remoteAttribute;
    NSString *_responseKeyPath;
    CKRequestMethod _requestMethod;
    BOOL _isInstanceMap;
    
    // Implement callback blocks
}

@property (nonatomic, assign) Class model;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSString *remotePath;
@property (nonatomic, retain) NSString *localAttribute;
@property (nonatomic, retain) NSString *remoteAttribute;
@property (nonatomic, retain) NSString *responseKeyPath;
@property (nonatomic, assign) CKRequestMethod requestMethod;
@property (nonatomic, assign) BOOL isInstanceMap;

+ (CKRouterMap *) map;

- (BOOL) isAttributeMap;
- (BOOL) isRelationshipMap;
- (BOOL) isRemotePathMap;

@end
