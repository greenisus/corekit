//
//  CKManager.m
//  CoreKit
//
//  Created by Matt Newberry on 7/14/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKManager.h"
#import "CKDefines.h"
#import "CKNSJSONSerialization.h"

@implementation CKManager

@synthesize serializationClass = _serializationClass;
@synthesize connectionClass = _connectionClass;
@synthesize coreData = _coreData;
@synthesize router = _router;
@synthesize baseURL = _baseURL;
@synthesize httpUser = _httpUser;
@synthesize httpPassword = _httpPassword;
@synthesize connection = _connection;
@synthesize serializer = _serializer;
@synthesize batchAllRequests = _batchAllRequests;
@synthesize secureAllConnections = _secureAllConnections;

#pragma mark -
# pragma mark Initializations

+ (CKManager *) sharedManager{
    
    static dispatch_once_t predicate;
    static CKManager *_shared = nil;
    
    dispatch_once(&predicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

- (id) init{
    
    if(self = [super init]){
        
        _coreData = [[CKCoreData alloc] init];
        _router = [[CKRouter alloc] init];
    }
    
    return self;
}

- (void) dealloc{
    
    RELEASE_SAFELY(_coreData);
    RELEASE_SAFELY(_router);
    RELEASE_SAFELY(_baseURL);
    RELEASE_SAFELY(_httpUser);
    RELEASE_SAFELY(_httpPassword);
    RELEASE_SAFELY(_connection);
    RELEASE_SAFELY(_serializer);
    
    [super dealloc];
}

- (CKManager *) setBaseURL:(NSString *) url user:(NSString *) user password:(NSString *) password{
    
    self.baseURL = url;
    self.httpUser = user;
    self.httpPassword = password;
    
    return self;
}

- (NSManagedObjectContext *) managedObjectContext{
    
    return self.coreData.managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel{
    
    return self.coreData.managedObjectModel;
}

- (id) parse:(id) object{
    
    return [self.serializer deserialize:object];
}

- (id) serialize:(id) object{
    
    return [self.serializer serialize:object];
}

- (id) serializer{
    
    if(_serializer == nil && _serializationClass != nil)
        _serializer = [[_serializationClass alloc] init];
    
    return _serializer;
}

- (void) sendRequest:(CKRequest *) request{
 
    id <CKConnection> conn = [[[_connectionClass alloc] init] autorelease];
    [conn send:request];
}

- (CKResult *) sendSyncronousRequest:(CKRequest *) request{
    
    id <CKConnection> conn = [[[_connectionClass alloc] init] autorelease];
    return [conn sendSyncronously:request];
}


@end
