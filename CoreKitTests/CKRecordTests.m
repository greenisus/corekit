//
//  CKRecordTests.m
//  CoreKit
//
//  Created by Matt Newberry on 7/19/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Order.h"
#import "CKNSJSONSerialization.h"

@interface CKRecordTests : SenTestCase

@end

@implementation CKRecordTests

- (void) testReturnEntityName{
    
    STAssertEqualObjects([Order entityName], @"Order", @"Failed to return entity name");
}

- (void) testFixtureLoadingByNameAndPath {
        
    id fixture = [Order fixtureByName:@"sample" atPath:@"Orders.json"];
    STAssertNotNil(fixture, @"Failed to load fixtures");
}

- (void) testFixtureLoadingByName{
    
    id fixture = [Order fixtureByName:@"sample"];
    STAssertNotNil(fixture, @"Failed to load fixture by name");
    STAssertTrue([fixture isKindOfClass:[NSDictionary class]], @"Sample fixture not a dictionary");
}

- (void) testLoadingAllFixtures{
    
    id fixtures = [Order fixtures];
    STAssertNotNil(fixtures, @"Failed to load all fixtures");
}

- (void) testBlank{
    
    Order *record = [Order blank];
    STAssertNotNil(record, @"Failed to create blank record");
}

- (void) testCreation{
    
    //NSDictionary *fixture = [Order fixture:@"sample"];
    
   // Order *record = [Order create:fixture];
    //STAssertNotNil(record, @"Failed to create record");
}

@end
