//
//  CKRouterMap.h
//  CoreKit
//
//  Created by Matt Newberry on 7/28/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRequest.h"

@interface CKRouterMap : NSObject

@property (nonatomic, assign) Class model;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSString *remotePath;
@property (nonatomic, strong) NSString *localAttribute;
@property (nonatomic, strong) NSString *remoteAttribute;
@property (nonatomic, strong) NSString *responseKeyPath;
@property (nonatomic, assign) CKRequestMethod requestMethod;
@property (nonatomic, assign) BOOL isInstanceMap;

+ (CKRouterMap *) map;
+ (CKRouterMap *) mapWithRemotePath:(NSString *) remotePath;

- (BOOL) isAttributeMap;
- (BOOL) isRelationshipMap;
- (BOOL) isRemotePathMap;

@end
