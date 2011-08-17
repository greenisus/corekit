//
//  CKManagerTests.m
//  CoreKit
//
//  Created by Matt Newberry on 7/14/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CKManager.h"
#import "CKCoreData.h"
#import "CKConnection.h"
#import "CKRequest.h"

@interface CKManagerTests : SenTestCase {
@private
    CKManager *_manager;
}

@end

@implementation CKManagerTests

- (void) setUp{
    
    _manager = [[CKManager sharedManager] setBaseURL:@"url.com" user:@"user" password:@"password"];
}

- (void) testReturnsSingleton{
    
    STAssertNotNil([CKManager sharedManager], @"Failed to create singleton");
}

- (void) testCoreDataInit{
    
    STAssertNotNil(_manager.coreData.managedObjectContext, @"Failed to init CoreData");
}

- (void) testBatchRequests{
    
    _manager.baseURL = @"http://search.twitter.com";
    CKRequest *request = [CKRequest request];
    request.remotePath = @"/search.json";
    [request addParameters:[NSDictionary dictionaryWithObject:@"rackspace" forKey:@"q"]];
    request.batch = YES;
        
    __block BOOL complete = NO;
    NSMutableArray *objects = [NSMutableArray array];
    
    request.completionBlock = ^(CKResult *result){
        
        [objects addObjectsFromArray:result.objects];
        //complete = YES;
    };
    
    [request send];
    
    while(complete == NO){
        // keep the main thread alive
        NSLog(@"NOOO");
    }
    
    int expectedResults = request.batchMaxPages * request.batchNumPerPage;
    NSLog(@"%i results ********************************************", [objects count]);
    STAssertEquals(expectedResults, [objects count], @"Failed to batch requests");
}


@end
