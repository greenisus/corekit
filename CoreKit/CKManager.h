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
#import "CKRequestQueue.h"
#import "CKRouter.h"

/** 
 * CKManager serves as the main coordinator for all things CoreKit. 
 */
@interface CKManager : NSObject{
        
    id <CKConnection> _connectionClass;
	id <CKSerialization> _serializationClass;
    
@private
    CKCoreData *_coreData;
    CKRequestQueue *_requestQueue;
    CKRouter *_router;
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
- (CKManager *) setSharedURL:(NSString *) url user:(NSString *) user password:(NSString *) password;


/** @name Serialization Methods */

/** Parse any object to / from native objects 
 
 @param object If NSData object, the method will serialize the object into an NSArray or NSDictionary, else the object will be serialized into an NSData object
 */
- (id) parse:(id) object;

/** @name Properties */

/** The class used to parse remote responses and also serialize native objects
 
 Must conform to protocol CKSerialization
 */
@property (nonatomic, assign) id <CKSerialization> serializationClass;

/** Used for all remote connections
 
 Must conform to protocol CKConnection
 */
@property (nonatomic, assign) id <CKConnection> connectionClass;

/** Creates and manages changes to the CoreData stack */
@property (nonatomic, readonly) CKCoreData *coreData;

/** Creates and manages routes */
@property (nonatomic, readonly) CKRouter *router;


@property (nonatomic, readonly) CKRequestQueue *requestQueue;

- (NSManagedObjectContext *) managedObjectContext;


@end
