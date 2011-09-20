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
#import "CKBindings.h"

/** 
 * CKManager serves as the main coordinator for all things CoreKit. 
 */
@interface CKManager : NSObject


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

/** The class used to parse local fixtures
 
 Must conform to protocol CKSerialization
 */
@property (nonatomic, assign) Class fixtureSerializationClass;

/** Used for all remote connections
 
 Must conform to protocol CKConnection
 */
@property (nonatomic, assign) Class connectionClass;

/** Creates and manages changes to the CoreData stack */
@property (nonatomic, readonly, strong) CKCoreData *coreData;

/** Creates and manages routes */
@property (nonatomic, readonly, strong) CKRouter *router;

/** Creates and manages bindings */
@property (nonatomic, readonly, strong) CKBindings *bindings;

/** Base URL used to append all resource paths to, ex: https://api.rackspace.com/v1.0/ */
@property (nonatomic, strong) NSString *baseURL;

/** HTTP Basic Auth user */
@property (nonatomic, strong) NSString *httpUser;

/** HTTP Basic Auth password */
@property (nonatomic, strong) NSString *httpPassword;

/** Keypath to response objects
 
 If response objects are not at the top level, you can specify the path to those objects (ex: Twitter, "results")
 */
@property (nonatomic, strong) NSString *responseKeyPath;

/** Internal connection instance */
@property (nonatomic, readonly, strong) id <CKSerialization> serializer;
@property (nonatomic, readonly, strong) id <CKSerialization> fixtureSerializer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *dateFormat;

/** Global setting to batch all remote requests.
 
 Can also be set on a per model basis
 */
@property (nonatomic, assign) BOOL batchAllRequests;

/** Global setting to secure all remote requests.
 
 Can also be set on a per model basis
 */
@property (nonatomic, assign) BOOL secureAllConnections;


- (BOOL) loadSeedFiles:(NSArray *) files groupName:(NSString *) groupName;
- (BOOL) loadSeedFilesForGroupName:(NSString *) groupName;
- (BOOL) loadAllSeedFiles;
+ (NSArray *) seedFiles;


- (NSManagedObjectContext *) managedObjectContext;
- (NSManagedObjectModel *) managedObjectModel;

- (void) sendRequest:(CKRequest *) request;
- (void) sendBatchRequest:(CKRequest *) request;
- (CKResult *) sendSyncronousRequest:(CKRequest *) request;


@end
