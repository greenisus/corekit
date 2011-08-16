//
//  CKURLConnectionTests.m
//  CoreKit
//
//  Created by Matt Newberry on 7/28/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CKRequest.h"
#import "CKManager.h"
#import "CKRecord+CKRouter.h"
#import "CKNSURLConnection.h"
#import "CKJSONKit.h"

@interface CKNSURLConnectionTests : SenTestCase

@end

@implementation CKNSURLConnectionTests

- (void) setUp{
    
    [[CKManager sharedManager] setConnectionClass:[CKNSURLConnection class]];
    [[CKManager sharedManager] setSerializationClass:[CKJSONKit class]];
}

- (void) testAsyncronous{
    
    [[CKManager sharedManager] setBaseURL:@"search.twitter.com"];
    
    CKRequest *request = [CKRequest request];
    request.remotePath = @"/search.json";
    [request addParameters:[NSDictionary dictionaryWithObject:@"rackspace" forKey:@"q"]];
    
    __block BOOL complete = NO;
    NSMutableArray *objects = [NSMutableArray array];
    
    request.completionBlock = ^(CKResult *result){
      
        complete = YES;
        [objects addObjectsFromArray:result.objects];
    };
    
    [request send];
    
    while(!complete){
        // keep the main thread alive
    }
    
    STAssertTrue([objects count] > 0, @"Failed to send async");
}

- (void) testSyncronously{
    
    [[CKManager sharedManager] setBaseURL:@"search.twitter.com"];
    
    CKRequest *request = [CKRequest request];
    request.remotePath = @"search.json";
    [request addParameters:[NSDictionary dictionaryWithObject:@"rackspace" forKey:@"q"]];
    
    CKResult *result = [request sendSyncronously];
    
    STAssertNotNil(result, @"Failed to send syncronous request");
    STAssertTrue([[result objects] count] > 0, @"Failed to send syncronous request");
}

@end