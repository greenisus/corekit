//
//  CKManager.m
//  CoreKit
//
//  Created by Matt Newberry on 7/14/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKManager.h"
#import "CKDefines.h"
#import "CKJSONKit.h"
#import "CKNSURLConnection.h"
#import "CKNSJSONSerialization.h"
#import "CKJSONKit.h"
#import <UIKit/UIKit.h>

@implementation CKManager

@synthesize serializationClass = _serializationClass;
@synthesize connectionClass = _connectionClass;
@synthesize coreData = _coreData;
@synthesize router = _router;
@synthesize baseURL = _baseURL;
@synthesize httpUser = _httpUser;
@synthesize httpPassword = _httpPassword;
@synthesize responseKeyPath = _responseKeyPath;
@synthesize connection = _connection;
@synthesize serializer = _serializer;
@synthesize dateFormatter = _dateFormatter;
@synthesize dateFormat = _dateFormat;
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
        _dateFormatter = [[NSDateFormatter alloc] init];
        _connectionClass = [CKNSURLConnection class];
        _serializationClass = [CKNSJSONSerialization class];
    }
    
    return self;
}

- (void) dealloc{
    
    RELEASE_SAFELY(_dateFormat);
    RELEASE_SAFELY(_dateFormatter);
    RELEASE_SAFELY(_coreData);
    RELEASE_SAFELY(_router);
    RELEASE_SAFELY(_baseURL);
    RELEASE_SAFELY(_httpUser);
    RELEASE_SAFELY(_httpPassword);
    RELEASE_SAFELY(_connection);
    RELEASE_SAFELY(_serializer);
    RELEASE_SAFELY(_responseKeyPath);
    
    [super dealloc];
}

- (CKManager *) setBaseURL:(NSString *) url user:(NSString *) user password:(NSString *) password{
    
    self.baseURL = url;
    self.httpUser = user;
    self.httpPassword = password;
    
    return self;
}

- (void) setDateFormat:(NSString *)dateFormat{
    
    [_dateFormatter setDateFormat:dateFormat];
    
    RELEASE_SAFELY(_dateFormat);
    _dateFormat = [dateFormat retain];
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
    
    if(request.batch && [conn respondsToSelector:@selector(sendBatchRequest:)])
        [conn performSelector:@selector(sendBatchRequest:) withObject:request];
    
    else if(request.batch && !request.isBatched)
        [self sendBatchRequest:request];
    
    else
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [conn send:request];
        });
}

- (void) sendBatchRequest:(CKRequest *) request{
    
    __block NSMutableArray *objects = [[NSMutableArray alloc] init];
    __block int pagesComplete = 0;
    
    for(int page = 1; page <= request.batchMaxPages; page++){
        
        CKRequest *pagedRequest = [CKRequest requestWithMap:request.routerMap];
        pagedRequest.isBatched = YES;
        pagedRequest.batchCurrentPage = page;
        [pagedRequest addParameters:request.parameters];
        
        NSLog(@"%@", [pagedRequest remoteURL]);
        
        pagedRequest.completionBlock = ^(CKResult *result){
            
            for(NSManagedObject *obj in result.objects)
                [objects addObject:[[CKManager sharedManager].managedObjectContext objectWithID:[obj objectID]]];
            
            pagesComplete++;
            
            if(pagesComplete == request.batchMaxPages){
                
                result.objects = objects;
                
                if(request.completionBlock != nil)
                    request.completionBlock(result);
                
                [objects release];
            }
        }; 
        
        [pagedRequest send];
    }
}

- (CKResult *) sendSyncronousRequest:(CKRequest *) request{
    
    id <CKConnection> conn = [[[_connectionClass alloc] init] autorelease];
    return [conn sendSyncronously:request];
}


@end
