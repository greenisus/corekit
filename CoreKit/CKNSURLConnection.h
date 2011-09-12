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
    NSURLConnection *_connection;
    NSDictionary *_responseHeaders;
}

@property (nonatomic, assign) NSUInteger responseCode;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) CKRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSDictionary *responseHeaders;

- (BOOL) connectionVerified;

@end
