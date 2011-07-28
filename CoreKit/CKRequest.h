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

typedef void (^CKResultBlock) (CKResult *result);
typedef void (^CKErrorBlock) (CKResult *result, NSError *error);
typedef void (^CKParseBlock) (id object);

/**
 * HTTP methods for requests
 */

typedef enum CKRequestMethod {
    CKRequestMethodGET = 1,
    CKRequestMethodPOST,
    CKRequestMethodPUT,
    CKRequestMethodDELETE,
    CKRequestMethodHEAD
} CKRequestMethod;

/**
 * Intervals for repeat requests
 */

typedef enum CKRequestInterval {
    CKRequestIntervalNone = 0,
    CKRequestIntervalAppDidEnterBackground = 999,
    CKRequestIntervalAppDidBecomeActive = 998,
    CKRequestIntervalEveryMinute = 60,
    CKRequsetIntervalEvery30Seconds = 30,
    CKRequestIntervalEvery10Seconds = 10
} CKRequestInterval;


/**
 * The standard request object for all HTTP requests
 */
@interface CKRequest : NSObject {
    
    NSString *_username;
    NSString *_password;
    NSString *_url;
    CKRequestMethod _method;
    
    NSMutableDictionary *_headers;
    NSMutableDictionary *_parameters;
    id _payload;
    
    BOOL _syncronous;
    BOOL _started;
    BOOL _completed;
    BOOL _failed;
    BOOL _batch;
    
    CKRequestInterval _interval;
    
    id <CKConnection> _connection;
    id <CKSerialization> _parser;
    
    CKResultBlock _completionBlock;
    CKErrorBlock _errorBlock;
    CKParseBlock _parsingBlock;
}

@end
