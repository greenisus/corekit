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

@interface CKManagerTests : SenTestCase {
@private
    CKManager *_manager;
}

@end

@implementation CKManagerTests

- (void) setUp{
    
    _manager = [[CKManager sharedManager] setSharedURL:@"url.com" user:@"user" password:@"password"];
}

- (void) testReturnsSingleton{
    
    STAssertNotNil([CKManager sharedManager], @"Failed to create singleton");
}

- (void) testCoreDataInit{
    
    STAssertNotNil(_manager.coreData.managedObjectContext, @"Failed to init CoreData");
}


@end
