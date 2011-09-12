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
#import "CKRecordPrivate.h"
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
    
    Order *order = [Order blank];
    
    order.name = @"Test";
    [order save];
    
    [order bindToSelector:@selector(selectorForTesting) inTarget:self forKeyPath:@"name" forChangeType:CKBindingChangeTypeAll];

    order.name = @"Test123";
    [order save];
    
    STAssertTrue(_testSelectorFired, @"Failed to fire test selector");    
}

- (void) selectorForTesting{
    _testSelectorFired = YES;
}

- (void) testFireBlock{
    
    __block BOOL blockFired = NO;
    
    Order *order = [Order blank];
    
    order.name = @"Test";
    [order save];
    
    [order bindTo:^{
        
        blockFired = YES;
        
    }];    
    
    order.name = @"Test123";
    [order save];

    STAssertTrue(blockFired, @"Failed to fire test block");
}

- (void) testUIObjects{
    
    Order *order = [Order blank];
    order.name = @"Test";
    [order save];
    
    UILabel *nameLabel = [UILabel alloc];
    [order bindTo:nameLabel forKeyPath:@"name"];
    
    order.name = @"Test123";
    [order save];    
    
    STAssertTrue([nameLabel.text isEqualToString:order.name], @"Failed to fire test control"); 
    
    
    UILabel *priceLabel = [UILabel alloc];
    [order bindTo:priceLabel forKeyPath:@"price"];
    
    order.price = [NSNumber numberWithFloat:99.99];
    [order save];
    
    STAssertTrue([priceLabel.text isEqualToString:@"99.99"], @"Failed to map number to label");
    
    
    UILabel *dateLabel = [UILabel alloc];
    [order bindTo:dateLabel forKeyPath:@"created_at"];
    
    order.created_at = [NSDate date];
    [order save];
        
    STAssertTrue([dateLabel.text isEqualToString:[order stringValueForKeyPath:@"created_at"]], @"Failed to map date to label");
}





@end