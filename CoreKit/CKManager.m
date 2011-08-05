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
        _serializationClass = [[CKNSJSONSerialization alloc] init];
        _router = [[CKRouter alloc] init];
    }
    
    return self;
}

- (CKManager *) setSharedURL:(NSString *) url user:(NSString *) user password:(NSString *) password{
    
    //RELEASE_SAFELY(_connection);
    //_connection = [[_connectionClass alloc] initWithURL:url user:user password:password];
    
    return self;
}

- (NSManagedObjectContext *) managedObjectContext{
    
    return self.coreData.managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel{
    
    return self.coreData.managedObjectModel;
}

- (id) parse:(id) object{
    
    return [_serializationClass deserialize:object];
}

- (id) serialize:(id) object{
    
    return [_serializationClass serialize:object];
}


@end
