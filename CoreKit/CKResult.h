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

@interface CKResult : NSObject <NSFastEnumeration>

@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) CKRequest *request;
@property (nonatomic, strong) NSData *responseBody;
@property (nonatomic, strong) NSDictionary *responseHeaders;
@property (nonatomic, assign) NSUInteger responseCode;

+ (CKResult *) resultWithRequest:(CKRequest *) request andResponseBody:(NSData *) responseBody;
+ (CKResult *) resultWithRequest:(CKRequest *) request andError:(NSError **) error;

- (id) initWithRequest:(CKRequest *) request responseBody:(NSData *) responseBody httpResponse:(NSHTTPURLResponse *) httpResponse error:(NSError **) error; 
- (id) initWithObjects:(NSArray *) objects; 
- (id) object;

@end
