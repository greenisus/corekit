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
 */
- (void) send:(CKRequest *) request;

/**
 Send a syncronous request
 
 @param request 
 @return CKResult object
 */
- (CKResult *) sendSyncronously:(CKRequest *) request;

@end