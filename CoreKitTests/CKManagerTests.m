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

@interface CKManagerTests : SenTestCase {
@private
    CKManager *_manager;
}

@end

@implementation CKManagerTests

- (void) setUp{
    
    _manager = [[CKManager sharedManager] managerWithURL:@"url.com" user:@"user" password:@"password"];
}

- (void) testReturnsSingleton{
    
    STAssertNotNil([CKManager sharedManager], @"Failed to create singleton");
}

- (void) testInitWithCredentials{
    
    STAssertEquals(_manager.credentials.user, @"user", @"Failed to store credentials");    
}

- (void) testCoreDataInit{
    
    STAssertNotNil(_manager.coreData.managedObjectContext, @"Failed to init CoreData");
}


@end
