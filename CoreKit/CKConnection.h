//
//  CKConnection.h
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CKRequest, CKResult;

/** 
 * CKConnection defines conforming methods for third-party HTTP connection libraries 
 */
@protocol CKConnection <NSObject>

@required 

/**
 Send asyncronous request
 
 @param request
 */
- (void) send:(CKRequest *) request;

/**
 Send a syncronous request
 
 @param request 
 @return CKResult object
 */
- (CKResult *) sendSyncronously:(CKRequest *) request;

@optional
/**
 Send a batched, asyncronous request.
 
 By default, CKManager will handle this for you with a series of enumerated requests. However, if your 3rd party connection library already implements this functionality, CKManager will fire this method instead.
 
 @param request 
 */
- (void) sendBatchRequest:(CKRequest *) request;

@end