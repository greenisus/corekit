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

@interface CKNSURLConnectionTests : SenTestCase

@end

@implementation CKNSURLConnectionTests

- (void) setUp{
    
}

- (void) testAsyncronous{
    
    [[CKManager sharedManager] setBaseURL:@"search.twitter.com"];
    
    CKRequest *request = [CKRequest requestWithRemotePath:@"search.json"];
    [request addParameters:[NSDictionary dictionaryWithObject:@"rackspace" forKey:@"q"]];
        
    NSMutableArray *objects = [NSMutableArray array];
    
    request.completionBlock = ^(CKResult *result){
      
        [objects addObjectsFromArray:result.objects];
    };
    
    [request send];
    
    while(!request.completed){
        // keep the main thread alive
    }
    
    STAssertTrue([objects count] > 0, @"Failed to send async");
}

- (void) testSyncronously{
    
    [[CKManager sharedManager] setBaseURL:@"search.twitter.com"];
    
    CKRequest *request = [CKRequest requestWithRemotePath:@"search.json"];
    [request addParameters:[NSDictionary dictionaryWithObject:@"rackspace" forKey:@"q"]];
    
    CKResult *result = [request sendSyncronously];
    
    STAssertNotNil(result, @"Failed to send syncronous request");
    STAssertTrue([[result objects] count] > 0, @"Failed to send syncronous request");
}

@end