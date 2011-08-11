//
//  CKResult.h
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CKRequest;

/** Standard interface to handle HTTP responses and local CoreData fetch requests */

@interface CKResult : NSObject{
    
    NSArray *_objects;
	NSError *_error;
	NSHTTPURLResponse *_httpResponse;
    id _response;
	
    CKRequest *_request;
}

@property (nonatomic, retain) NSArray *objects;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) NSHTTPURLResponse *httpResponse;
@property (nonatomic, retain) CKRequest *request;
@property (nonatomic, retain) id response;

+ (CKResult *) resultWithRequest:(CKRequest *) request andResponse:(id) response;
+ (CKResult *) resultWithRequest:(CKRequest *) request andError:(NSError **) error;
- (id) initWithRequest:(CKRequest *) request response:(id) response httpResponse:(NSHTTPURLResponse *) httpResponse error:(NSError **) error; 
- (id) initWithObjects:(NSArray *) objects; 
- (void) setResponse:(id) response;

@end
