//
//  CKRouterMap.m
//  CoreKit
//
//  Created by Matt Newberry on 7/28/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRouterMap.h"
#import "CKRecord.h"

@implementation CKRouterMap

@synthesize model = _model;
@synthesize path = _path;
@synthesize localAttribute = _localAttribute;
@synthesize remoteAttribute = _remoteAttribute;
@synthesize requestMethod = _requestMethod;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (CKRouterMap *) map{
    
    return [[[CKRouterMap alloc] init] autorelease];
}

- (BOOL) isAttributeMap{
    
    return ([_localAttribute length] > 0 && [_remoteAttribute length] > 0);
}

- (BOOL) isRelationshipMap{
    
    NSEntityDescription *entity = [_model entityDescription];
    
    if(entity){
        
        return [[[entity relationshipsByName] allKeys] containsObject:_localAttribute];
    }
    
    return NO;
}

- (BOOL) isRemotePathMap{
    
    return [_path length] > 0;
}

@end
