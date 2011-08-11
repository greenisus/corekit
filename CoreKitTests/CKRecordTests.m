//
//  CKRecordTests.m
//  CoreKit
//
//  Created by Matt Newberry on 7/19/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Order.h"
#import "OrderItem.h"
#import "CKNSJSONSerialization.h"
#import "CKManager.h"
#import "CKRequest.h"
#import "CKRecord+CKRouter.h"

@interface CKRecordTests : SenTestCase{
    
    id _defaultFixture;
}

@end

@implementation CKRecordTests

- (void) setUp{
    
    if(_defaultFixture == nil){
        
        _defaultFixture = [[Order fixtureNamed:@"sample"] retain];
        [CKManager sharedManager].serializationClass = [CKNSJSONSerialization class];
    }
}

- (void) tearDown{
    
    [Order removeAll];
}

- (void) testReturnEntityName{
    
    STAssertEqualObjects([Order entityName], @"Order", @"Failed to return entity name");
}

- (void) testFixtureLoadingByNameAndPath {
        
    id fixture = [Order fixtureNamed:@"sample" atPath:@"Orders.json"];
    
    STAssertNotNil(fixture, @"Failed to load fixtures");
}

- (void) testFixtureLoadingByName{
    
    STAssertNotNil(_defaultFixture, @"Failed to load fixture by name");
    STAssertTrue([_defaultFixture isKindOfClass:[NSDictionary class]], @"Sample fixture not a dictionary");
}

- (void) testLoadingAllFixtures{
        
    id fixtures = [Order fixtures];
    
    STAssertNotNil(fixtures, @"Failed to load all fixtures");
}

- (void) testLoadingAllFixturesAsAnArray{
    
    NSArray *fixtures = [Order fixturesAsArray];
    
    STAssertEquals([fixtures count], [[[Order fixtures] allKeys] count], @"Failed to load fixtures as an array");
}

- (void) testBlank{
    
    Order *record = [Order blank];
    
    STAssertNotNil(record, @"Failed to create blank record");
}

- (void) testCreation{
        
    Order *record = [Order create:_defaultFixture];
    
    STAssertNotNil(record, @"Failed to create record");
}

- (void) testBatchCreation{
        
    [Order removeAll];
    [Order save];
        
    NSArray *fixtures = [Order fixturesAsArray];
    NSArray *newItems = [Order create:[Order fixturesAsArray]];
        
    STAssertEquals([newItems count], [fixtures count], @"Failed to batch create orders");
}

- (void) testUpdate{
    
    NSString *name = [_defaultFixture objectForKey:@"name"];
    NSNumber *orderID = [_defaultFixture objectForKey:@"id"];
    
    Order *record = [Order blank];
    [record update:_defaultFixture];
        
    STAssertEqualObjects(record.name, name, @"Failed to update object name");
    STAssertEqualObjects(record.id, orderID, @"Failed to update object id");
    STAssertNotNil(record.created_at, @"Failed to set date for object");
}

- (void) testBuildRecords{
    
    Order *record = [Order create:_defaultFixture];
    [record save];
    
    [Order build:_defaultFixture];
    [Order save];
    
    STAssertEquals((int) [Order count], 1, @"Failed to update existing object via build");
}

- (void) testUpdatingWithPredicate{
    
    Order *record = [Order create:_defaultFixture];
    [Order save];
    NSString *name = record.name;
    
    [Order updateWithPredicate:[NSPredicate predicateWithFormat:@"name = %@", name] withData:[NSDictionary dictionaryWithObject:@"Bob" forKey:@"name"]];
    
    STAssertTrue([record isUpdated], @"Failed to update with a predicate");
}

- (void) testRelationshipMapping{
    
    Order *record = [Order create:_defaultFixture];
    STAssertTrue(([record.items count] > 0), @"Failed to create relationship");
}

- (void) testRemove{
    
    Order *record = [Order create:_defaultFixture];
    [Order save];
    [record remove];
    
    STAssertTrue([record isDeleted], @"Failed to delete object");
}

- (void) testRemovingAllRecords{
    
    [Order removeAll];
    
    STAssertEquals((int) [Order count], 0, @"Failed to remove all objects");
}

- (void) testRemovingAllRecordsWithPredicate{
    
    Order *record = [Order create:_defaultFixture];
    [Order create:[Order fixtureNamed:@"large"]];
    [Order removeAllWithPredicate:[NSPredicate predicateWithFormat:@"name BEGINSWITH %@", record.name]];
    
    STAssertEquals((int) [Order count], 1, @"Failed to remove all objects using a predicate");
}

- (void) testReturningAll{
    
    NSArray *records = [Order all];
    
    STAssertEquals([records count], [Order count], @"Failed to return all records");
}

- (void) testFindAndSort{
    
    [Order create:[Order fixturesAsArray]];
    
    NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO] autorelease];
    NSArray *all = [[Order all] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    NSArray *records = [Order findWithPredicate:nil sortedBy:@"name DESC"  withLimit:0];
    
    STAssertEqualObjects([all objectAtIndex:0], [records objectAtIndex:0], @"Failed to sort all");
}

- (void) testFindingWithAttributeEqualStrings{
    
    Order *record = [Order create:_defaultFixture];
    NSArray *records = [Order findWhereAttribute:@"name" equals:record.name];
    NSUInteger count = [Order countWithPredicate:[NSPredicate predicateWithFormat:@"name == %@", record.name]];
    
    STAssertEquals([records count], count, @"Failed to find with equal strings");
}

- (void) testFindingWithAttributeEqualNumbers{
    
    Order *record = [Order create:_defaultFixture];
    NSArray *records = [Order findWhereAttribute:@"id" equals:record.id];
    NSUInteger count = [Order countWithPredicate:[NSPredicate predicateWithFormat:@"id == %@", record.id]];
    
    STAssertEquals([records count], count, @"Failed to find with equal numbers");
}

- (void) testFindingWithAttributeEqualDates{
    
    Order *record = [Order create:_defaultFixture];
    NSArray *records = [Order findWhereAttribute:@"created_at" equals:record.created_at];
    NSUInteger count = [Order countWithPredicate:[NSPredicate predicateWithFormat:@"created_at == %@", record.created_at]];
    
    STAssertEquals([records count], count, @"Failed to find with equal dates");
}

- (void) testFindingWhereAttributeContainsString{
    
    Order *record = [Order create:_defaultFixture];
    NSArray *records = [Order findWhereAttribute:@"name" contains:[record.name substringToIndex:3]];
    
    STAssertTrue(([records count] > 0), @"Failed to find with containment");
}

- (void) testFindingAverage{
    
    [Order create:[Order fixturesAsArray]];
    
    __block float total = 0;
    __block int count = 0;
    
    [[Order all] enumerateObjectsUsingBlock:^(Order* obj, NSUInteger idx, BOOL *stop){
       
        total += [obj.price floatValue];
        count++;
    }];
    
    STAssertEquals([[Order average:@"price"] floatValue], (float) total / count, @"Failed to average numbers");
}

- (void) testProperURLFormatting{
    
    [[CKManager sharedManager] setBaseURL:@"shopify.com/"];
    
    Order *record = [Order create:_defaultFixture];
    CKRequest *request = [record requestForGet];
    
    STAssertEqualObjects([request remoteURL].absoluteString, @"http://shopify.com/orders/1", @"Failed to properly format URL");
    
    [Order mapInstancesToRemotePath:@"//orders/(id)"];
    CKRequest *request1 = [record requestForGet];
    request1.batch = YES;
    
    STAssertEqualObjects([[request1 remoteURL] absoluteString], @"http://shopify.com/orders/1?limit=50", @"Failed to properly format URL");
}

@end
