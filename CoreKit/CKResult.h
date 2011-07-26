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
	
    CKRequest *_request;
}

@property (nonatomic, retain) NSArray *objects;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) NSHTTPURLResponse *httpResponse;
@property (nonatomic, retain) CKRequest *request;

- (id) initWithRequest:(CKRequest *) request objects:(NSArray *) objects httpResponse:(NSHTTPURLResponse *) httpResponse error:(NSError **) error; 
- (id) initWithObjects:(NSArray *) objects; 

@end
