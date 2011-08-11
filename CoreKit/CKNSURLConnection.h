//
//  CKNSURLConnection.h
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKConnection.h"
#import "CKRequest.h"

@interface CKNSURLConnection : NSObject <CKConnection, NSURLConnectionDelegate>{
    
    NSUInteger _responseCode;
    NSMutableData *_responseData;
	CKRequest *_request;
}

@property (nonatomic, assign) NSUInteger responseCode;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) CKRequest *request;

- (BOOL) connectionVerified;
- (void) sendBatch;

@end
