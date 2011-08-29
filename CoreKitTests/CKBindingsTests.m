//
//  CKRouterTests.m
//  CoreKit
//
//  Created by Matt Newberry on 7/28/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "CKBindings.h"
#import "CKBindingMap.h"
#import "CKRecord+CKBindings.h"
#import "Order.h"
#import "CKManager.h"



@interface CKBindingsTests : SenTestCase{
    
    CKBindings *_bindings;
    BOOL _testSelectorFired;
}

@end

@implementation CKBindingsTests

- (void) setUp{
    
    if(_bindings == nil){
        
        [CKManager sharedManager];
        _bindings = [CKBindings sharedBindings];
    }
}

- (void) tearDown{
    
    [Order removeAll];
    [_bindings.bindings removeAllObjects];
}

- (void) testSharedRouter{
    
    STAssertNotNil([CKBindings sharedBindings], @"Failed to return shared instance");
}

- (void) testAddMap{
    
    CKBindingMap *map = [CKBindingMap map];
    map.entityClass = [Order class];
    map.target = self;
    map.selector = @selector(selectorForTesting);
    [_bindings addMap:map];
    
    STAssertTrue([[_bindings.bindings allKeys] count] > 0, @"Failed to add router map");
}

- (void) testFireSelector{
    
    CKBindingMap *map = [CKBindingMap map];
    map.entityClass = [Order class];
    map.target = self;
    map.selector = @selector(selectorForTesting);
    [_bindings addMap:map];
    
    Order *order = [Order blank];
    order.name = @"Test";
    [order save];
    order.name = @"Test123";
    [order save];
    
    STAssertTrue(_testSelectorFired, @"Failed to fire test selector");    
}

- (void) selectorForTesting{
    _testSelectorFired = YES;
}

- (void) testFireBlock{
    
    __block BOOL blockFired = NO;
    
    CKBindingMap *map = [CKBindingMap map];
    map.entityClass = [Order class];
    map.block = ^(CKBindingMap *map){
        blockFired = YES;
    };
    [_bindings addMap:map];
    
    Order *order = [Order blank];
    order.name = @"Test";
    [order save];
    order.name = @"Test123";
    [order save];

    STAssertTrue(blockFired, @"Failed to fire test block");
}

- (void) testLabel{
    
    Order *order = [Order blank];
    order.name = @"Test";
    [order save];
    
    UILabel *label = [[[UILabel alloc] init] autorelease];
    
    [order bindToControl:label forKeyPath:@"name"];
    
    order.name = @"Test123";
    [order save];
    
    STAssertTrue([label.text isEqualToString:order.name], @"Failed to fire test control");    
}





@end