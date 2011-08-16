//
//  CKRequest.h
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKConnection.h"
#import "CKSerialization.h"
#import "CKResult.h"

@class CKRouterMap;

typedef void (^CKResultBlock) (CKResult *result);
typedef void (^CKErrorBlock) (CKResult *result, NSError **error);
typedef void (^CKParseBlock) (id object);

/**
 * HTTP methods for requests
 */

typedef enum CKRequestMethod {
    CKRequestMethodGET = 1,
    CKRequestMethodPOST,
    CKRequestMethodPUT,
    CKRequestMethodDELETE,
    CKRequestMethodHEAD,
    CKRequestMethodALL
} CKRequestMethod;

/**
 * Intervals for repeat requests
 */

typedef enum CKRequestInterval {
    CKRequestIntervalNone = 0,
    CKRequestIntervalEvery10Seconds = 10,
    CKRequsetIntervalEvery30Seconds = 30,
    CKRequestIntervalEveryMinute = 60,
    CKRequestIntervalAppDidBecomeActive = 998,
    CKRequestIntervalAppDidEnterBackground = 999
} CKRequestInterval;


/**
 * The standard request object for all HTTP requests
 */
@interface CKRequest : NSObject {
    
    CKRouterMap *_routerMap;
    
    NSString *_username;
    NSString *_password;
    NSString *_remotePath;
    CKRequestMethod _method;
    
    NSMutableDictionary *_headers;
    NSMutableDictionary *_parameters;
    id _body;
    
    BOOL _syncronous;
    BOOL _started;
    BOOL _completed;
    BOOL _failed;
    BOOL _secure;
    
    BOOL _batch;
    BOOL _isBatched;
    NSString *_batchPageString;
    NSString *_batchMaxPerPageString;
    NSUInteger _batchNumPerPage;
    NSUInteger _batchMaxPages;
    
    NSUInteger _connectionTimeout;
    
    CKRequestInterval _interval;
    
    id <CKConnection> _connection;
    id <CKSerialization> _parser;
    
    CKResultBlock _completionBlock;
    CKErrorBlock _errorBlock;
    CKParseBlock _parseBlock;
}

@property (nonatomic, retain) CKRouterMap *routerMap;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *remotePath;
@property (nonatomic, assign) CKRequestMethod method;
@property (nonatomic, retain) NSMutableDictionary *headers;
@property (nonatomic, retain) NSMutableDictionary *parameters;
@property (nonatomic, retain) id body;
@property (nonatomic, assign) BOOL syncronous;
@property (nonatomic, assign) BOOL started;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, assign) BOOL failed;
@property (nonatomic, assign) BOOL isBatched;
@property (nonatomic, assign) BOOL batch;
@property (nonatomic, assign) BOOL secure;
@property (nonatomic, retain) NSString *batchPageString;
@property (nonatomic, retain) NSString *batchMaxPerPageString;
@property (nonatomic, assign) NSUInteger batchNumPerPage;
@property (nonatomic, assign) NSUInteger batchMaxPages;
@property (nonatomic, assign) NSUInteger connectionTimeout;
@property (nonatomic, assign) CKRequestInterval interval;
@property (nonatomic, retain) id connection;
@property (nonatomic, retain) id parser;
@property (nonatomic, assign) CKResultBlock completionBlock;
@property (nonatomic, assign) CKErrorBlock errorBlock;
@property (nonatomic, assign) CKParseBlock parseBlock;

+ (CKRequest *) request;
+ (CKRequest *) requestWithMap:(CKRouterMap *) map;
- (NSURLCredential *) credentials;
- (NSString *) methodString;
- (NSURL *) remoteURL;
- (NSMutableURLRequest *) remoteRequest;
- (void) addParameters:(NSDictionary *) data;
- (void) addHeaders:(NSDictionary *) data;
- (void) send;
- (CKResult *) sendSyncronously;

@end
