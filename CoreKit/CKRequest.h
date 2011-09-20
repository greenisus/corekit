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

typedef void (^CKBasicBlock) ();
typedef void (^CKResultBlock) (CKResult *result);
typedef void (^CKParseBlock) (id object);
typedef id (^CKFormatBlock) (id object);


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
@interface CKRequest : NSObject

@property (nonatomic, strong) CKRouterMap *routerMap;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *remotePath;
@property (nonatomic, assign) CKRequestMethod method;
@property (nonatomic, strong) NSMutableDictionary *headers;
@property (nonatomic, strong) NSMutableDictionary *parameters;
@property (nonatomic, strong) id body;
@property (nonatomic, assign) BOOL syncronous;
@property (nonatomic, assign) BOOL started;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, assign) BOOL failed;
@property (nonatomic, assign) BOOL isBatched;
@property (nonatomic, assign) BOOL batch;
@property (nonatomic, assign) BOOL secure;
@property (nonatomic, strong) NSString *batchPageString;
@property (nonatomic, strong) NSString *batchMaxPerPageString;
@property (nonatomic, assign) NSUInteger batchNumPerPage;
@property (nonatomic, assign) NSUInteger batchMaxPages;
@property (nonatomic, assign) NSUInteger batchCurrentPage;
@property (nonatomic, assign) NSUInteger connectionTimeout;
@property (nonatomic, assign) CKRequestInterval interval;
@property (nonatomic, strong) id connection;
@property (nonatomic, strong) id parser;
@property (nonatomic, copy) CKResultBlock completionBlock;
@property (nonatomic, copy) CKResultBlock errorBlock;
@property (nonatomic, copy) CKParseBlock parseBlock;

+ (CKRequest *) request;
+ (CKRequest *) requestWithRemotePath:(NSString *) remotePath;
+ (CKRequest *) requestWithMap:(CKRouterMap *) map;
- (NSURLCredential *) credentials;
- (NSString *) methodString;
- (NSURL *) remoteURL;
- (NSMutableURLRequest *) remoteRequest;
- (void) addParameters:(NSDictionary *) data;
- (void) addHeaders:(NSDictionary *) data;
- (void) send;
- (CKResult *) sendSyncronously;
- (void) scheduleRepeatRequest;

@end
