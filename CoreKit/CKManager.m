//
//  CKManager.m
//  CoreKit
//
//  Created by Matt Newberry on 7/14/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKManager.h"

@implementation CKManager

@synthesize baseURL = _baseURL;
@synthesize credentials = _credentials;
@synthesize serializationClass = _serializationClass;
@synthesize connectionClass = _connectionClass;
@synthesize fixtureParsingClass = _fixtureParsingClass;
@synthesize coreData = _coreData;

#pragma mark -
# pragma mark Initializations

+ (CKManager *) sharedManager{
    
    static dispatch_once_t predicate = 0;
    static CKManager *_shared = nil;
    
    dispatch_once(&predicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

- (id) init{
    
    if(self = [super init]){
        
        _coreData = [[CKCoreData alloc] init];
    }
    
    return self;
}

- (CKManager *) managerWithURL:(NSString *) url user:(NSString *) user password:(NSString *) password{
    
    CKManager *manager = [CKManager sharedManager];
    manager.baseURL = url;
    manager.credentials = [NSURLCredential credentialWithUser:user password:password persistence:NSURLCredentialPersistenceForSession];
    
    return manager;
}



@end
