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

@interface CKResult : NSObject <NSFastEnumeration>{
    
    NSArray *_objects;
	NSError *_error;
	NSHTTPURLResponse *_httpResponse;
    id _response;
	
    CKRequest *_request;
}

@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSHTTPURLResponse *httpResponse;
@property (nonatomic, strong) CKRequest *request;
@property (nonatomic, strong) id response;

+ (CKResult *) resultWithRequest:(CKRequest *) request andResponse:(id) response;
+ (CKResult *) resultWithRequest:(CKRequest *) request andError:(NSError **) error;
- (id) initWithRequest:(CKRequest *) request response:(id) response httpResponse:(NSHTTPURLResponse *) httpResponse error:(NSError **) error; 
- (id) initWithObjects:(NSArray *) objects; 
- (id) object;

@end
