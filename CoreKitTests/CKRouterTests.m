//
//  CKRouterTests.m
//  CoreKit
//
//  Created by Matt Newberry on 7/28/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CKRouter.h"
#import "CKRouterMap.h"
#import "CKRequest.h"
#import "Order.h"
#import "OrderItem.h"
#import "CKRecord+CKRouter.h"

@interface CKRouterTests : SenTestCase{
    
    CKRouter *_router;
}

@end

@implementation CKRouterTests

- (void) setUp{
    
    if(_router == nil)
        _router = [CKRouter sharedRouter];
}

- (void) tearDown{
    
    [_router.routes removeAllObjects];
}

- (void) testSharedRouter{
    
    STAssertNotNil([CKRouter sharedRouter], @"Failed to return shared router");
}

- (void) testAddMap{
    
    CKRouterMap *map = [CKRouterMap map];
    map.model = [Order class];
    [_router addMap:map];
    
    STAssertTrue([[_router.routes allKeys] count] > 0, @"Failed to add router map");
}

- (void) testReturnMapsForModel{
    
    CKRouterMap *map = [CKRouterMap map];
    map.model = [Order class];
    [_router addMap:map];
    
    NSArray *maps = [_router mapsForModel:[Order class]];
    STAssertTrue([maps count] == 1, @"Failed to return maps for model");
}

- (void) testAttributeMapForModel{
    
    CKRouterMap *map = [CKRouterMap map];
    map.model = [Order class];
    map.localAttribute = @"local";
    map.remoteAttribute = @"remote";
    [_router addMap:map];
    
    NSDictionary *attributeMap = [_router attributeMapForModel:map.model];
    STAssertTrue([[attributeMap allKeys] containsObject:map.localAttribute] && [[attributeMap objectForKey:map.localAttribute] isEqualToString:map.remoteAttribute], @"Failed to return proper attribute map");
}

- (void) testLocalAttributeForRemoteKey{
    
    CKRouterMap *map = [CKRouterMap map];
    map.model = [Order class];
    map.localAttribute = @"local";
    map.remoteAttribute = @"remote";
    [_router addMap:map];
    
    NSString *localAttribute = [_router localAttributeForRemoteKey:map.remoteAttribute forModel:map.model];
    STAssertEqualObjects(map.localAttribute, localAttribute, @"Failed to return local attribute for remote key"); 
}

- (void) testRemoteKeyForLocalAttribute{
    
    CKRouterMap *map = [CKRouterMap map];
    map.model = [Order class];
    map.localAttribute = @"local";
    map.remoteAttribute = @"remote";
    [_router addMap:map];
    
    NSString *remoteKey = [_router remoteKeyForLocalAttribute:map.localAttribute forModel:map.model];
    STAssertEqualObjects(map.remoteAttribute, remoteKey, @"Failed to return local attribute for remote key"); 
}

- (void) testMapsForModelRequestMethod{
    
    CKRouterMap *map = [CKRouterMap map];
    map.model = [Order class];
    map.requestMethod = CKRequestMethodGET;
    [_router addMap:map];
    
    CKRouterMap *returned = [_router mapForModel:map.model forRequestMethod:map.requestMethod];
    STAssertEqualObjects(map, returned, @"Failed to return map for model request method");
}

- (void) testMapForRelationship{
    
    CKRouterMap *map = [CKRouterMap map];
    map.model = [Order class];
    map.localAttribute = @"items";
    map.remotePath = @"/orders/items";
    map.requestMethod = CKRequestMethodGET;
    [_router addMap:map];
    
    CKRouterMap *returned = [_router mapForRelationship:map.localAttribute forModel:map.model andRequestMethod:map.requestMethod];
    STAssertEqualObjects(map, returned, @"Failed to return map for model relationship");
}

- (void) testMapModelToRemotePath{
    
    [_router mapModel:[Order class] toRemotePath:@"/orders" forRequestMethod:CKRequestMethodGET];
    
    CKRouterMap *map = [_router mapForModel:[Order class] forRequestMethod:CKRequestMethodGET];
    
    STAssertEqualObjects(map.remotePath, @"/orders", @"Failed to map remote model to path");
}

- (void) testMapRelationshipToRemotePath{
    
    [_router mapRelationship:@"items" forModel:[Order class] toRemotePath:@"/orders/items" forRequestMethod:CKRequestMethodGET];
    
    CKRouterMap *map = [_router mapForRelationship:@"items" forModel:[Order class] andRequestMethod:CKRequestMethodGET];
    
    STAssertEqualObjects(map.localAttribute, @"items", @"Failed to map remote relationship to path");
}

- (void) testMapLocalAttributeToRemoteKey{
    
    NSString *localAttribute = @"created_at";
    NSString *remoteAttribtue = @"createdAt";
    
    [_router mapLocalAttribute:localAttribute toRemoteKey:remoteAttribtue forModel:[Order class]];
    
    NSDictionary *attributeMap = [_router attributeMapForModel:[Order class]];
    
    STAssertTrue([[attributeMap allKeys] containsObject:localAttribute] && [[attributeMap objectForKey:localAttribute] isEqualToString:remoteAttribtue], @"Failed to return proper attribute map");
}


- (void) testRecordMappingForGet{
    
    CKRouterMap *map = [Order mapForRequestMethod:CKRequestMethodGET];
    
    STAssertEqualObjects(map.remotePath, @"orders", @"Failed to map class GET");
}

- (void) testRecordMappingOfInstance{
    
    Order *order = [Order blank];
    order.id = [NSNumber numberWithInt:12345];
    [order save];
    
    CKRouterMap *map = [order mapForRequestMethod:CKRequestMethodALL];
    
    STAssertEqualObjects(map.remotePath, @"orders/12345", @"Failed to map instance router");
}

- (void) testStaticRelationshipMapping{
    
    Order *order = [Order blank];
    order.id = [NSNumber numberWithInt:1];
    [order save];
    
    OrderItem *item = [OrderItem blank];
    item.order = order;
    item.id = [NSNumber numberWithInt:2];
    [item save];
        
    [OrderItem mapInstancesToRemotePath:@"/orders/(order.id)/items/(id)"];
    
    CKRouterMap *map = [item mapForRequestMethod:CKRequestMethodALL];
    
    STAssertEqualObjects(map.remotePath, @"/orders/1/items/2", @"Failed to map relationships to remote URL");
}

- (void) testClassLevelRelationshipMapping{
    
    Order *order = [Order blank];
    order.id = [NSNumber numberWithInt:1];
    [order save];
    
    CKRouterMap *map = [order mapForRelationship:@"items"];
    
    STAssertEqualObjects(map.remotePath, @"orders/1/items", @"Failed to map class level relationship");
}

@end