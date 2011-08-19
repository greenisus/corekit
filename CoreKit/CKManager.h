//
//  CKManager.h
//  CoreKit
//
//  Created by Matt Newberry on 7/14/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKCoreData.h"
#import "CKConnection.h"
#import "CKSerialization.h"
#import "CKRouter.h"

/** 
 * CKManager serves as the main coordinator for all things CoreKit. 
 */
@interface CKManager : NSObject{
        
    Class _connectionClass;
	Class _serializationClass;
    
    NSString *_baseURL;
    NSString *_httpUser;
    NSString *_httpPassword;
    
    NSString *_responseKeyPath;
    
    BOOL _batchAllRequests;
    BOOL _secureAllConnections;
    
    CKCoreData *_coreData;
    CKRouter *_router;
    
    NSDateFormatter *_dateFormatter;
    NSString *_dateFormat;
    
@private
    id <CKConnection> _connection;
    id <CKSerialization> _serializer;
}


/** @name Getting the Shared Manager */

/** Returns the CKManager singleton which is automatically created */
+ (CKManager *) sharedManager;


/** @name Setting the Base URL and Authentication Credentials */

/** Convience method to easily create the property credentials 
 
 @param url the property baseURL to be used for remote connections
 @param user Username for HTTP authentication
 @param password Password for HTTP authentication
 */
- (CKManager *) setBaseURL:(NSString *) url user:(NSString *) user password:(NSString *) password;


/** @name Serialization Methods */

/** Parse any object to native objects 
 
 */
- (id) parse:(id) object;


/** Serialize a native object to NSString
 
 */
- (id) serialize:(id) object;

/** @name Properties */

/** The class used to parse remote responses and also serialize native objects
 
 Must conform to protocol CKSerialization
 */
@property (nonatomic, assign) Class serializationClass;

/** Used for all remote connections
 
 Must conform to protocol CKConnection
 */
@property (nonatomic, assign) Class connectionClass;

/** Creates and manages changes to the CoreData stack */
@property (nonatomic, readonly, retain) CKCoreData *coreData;

/** Creates and manages routes */
@property (nonatomic, readonly, retain) CKRouter *router;

@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *httpUser;
@property (nonatomic, retain) NSString *httpPassword;
@property (nonatomic, retain) NSString *responseKeyPath;
@property (nonatomic, readonly, retain) id <CKConnection> connection;
@property (nonatomic, readonly, retain) id <CKSerialization> serializer;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSString *dateFormat;

@property (nonatomic, assign) BOOL batchAllRequests;
@property (nonatomic, assign) BOOL secureAllConnections;



- (NSManagedObjectContext *) managedObjectContext;
- (NSManagedObjectModel *) managedObjectModel;

- (void) sendRequest:(CKRequest *) request;
- (void) sendBatchRequest:(CKRequest *) request;
- (CKResult *) sendSyncronousRequest:(CKRequest *) request;


@end
