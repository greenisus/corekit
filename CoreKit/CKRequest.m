//
//  CKRequest.m
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRequest.h"
#import "CKDefines.h"

@implementation CKRequest

@synthesize routerMap = _routerMap;
@synthesize username = _username;
@synthesize password = _password;
@synthesize remotePath = _remotePath ;
@synthesize method = _method;
@synthesize headers = _headers;
@synthesize parameters = _parameters;
@synthesize body = _body;
@synthesize syncronous = _syncronous;
@synthesize started = _started;
@synthesize completed = _completed;
@synthesize failed = _failed;
@synthesize batch = _batch;
@synthesize interval = _interval;
@synthesize connection = _connection;
@synthesize parser = _parser;
@synthesize completionBlock = _completionBlock;
@synthesize errorBlock = _errorBlock;
@synthesize parseBlock = _parseBlock;

- (id) initWithRouterMap:(CKRouterMap *) map{

    if (self = [super init]) {
        
        _interval = CKRequestIntervalNone;
        _headers = [[NSMutableDictionary alloc] init];
        _parameters = [[NSMutableDictionary alloc] init];
        self.routerMap = map;
    }
    
    return self;
}

+ (CKRequest *) request{
    
    return [self requestWithMap:nil];
}

+ (CKRequest *) requestWithMap:(CKRouterMap *) map{
    
    return [[[self alloc] initWithRouterMap:map] autorelease];
}

- (void) addHeaders:(NSDictionary *) data{
    
    [_headers addEntriesFromDictionary:data];
}

- (void) addParameters:(NSDictionary *) data{
    
    [_parameters addEntriesFromDictionary:data];
}

- (void) setRouterMap:(CKRouterMap *)routerMap{
    
    RELEASE_SAFELY(_routerMap);
    _routerMap = [routerMap retain];
    
    self.remotePath = _routerMap.remotePath;
    self.method = _routerMap.requestMethod;
}

- (void) dealloc{
    
    RELEASE_SAFELY(_routerMap);
    RELEASE_SAFELY(_username);
    RELEASE_SAFELY(_password);
    RELEASE_SAFELY(_remotePath);
    RELEASE_SAFELY(_headers);
    RELEASE_SAFELY(_parameters);
    RELEASE_SAFELY(_connection);
    RELEASE_SAFELY(_body);
    RELEASE_SAFELY(_parser);

    [super dealloc];
}

@end
