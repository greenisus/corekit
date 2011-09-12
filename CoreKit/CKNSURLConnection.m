//
//  CKNSURLConnection.m
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKNSURLConnection.h"
#import "CKDefines.h"
#import "CKSupport.h"
#import "CKManager.h"
#import "NSString+InflectionSupport.h"
#import <UIKit/UIKit.h>

@implementation CKNSURLConnection

@synthesize responseCode = _responseCode;
@synthesize responseData = _responseData;
@synthesize request = _request;
@synthesize connection = _connection;
@synthesize responseHeaders = _responseHeaders;

- (id) init{
    
    if(self = [super init]){
        
        _responseData = [[NSMutableData alloc] init];
    }
    
    return self;
}

-(BOOL) connectionVerified{
    
    BOOL connected = CK_CONNECTION_AVAILABLE();
    
	if(!connected){
        
        //standardized way to handle errors?
    }
    
	return connected;
}

- (void) send:(CKRequest *) request{
    
    self.request = request;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if(![self connectionVerified])
		return;
        
    _connection = [[NSURLConnection	alloc] initWithRequest:[_request remoteRequest] delegate:self];
    self.request.connection = _connection;
    
    do {
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:_request.connectionTimeout]];
    } while (!self.request.completed);
    
}

- (CKResult *) sendSyncronously:(CKRequest *) request{
	
    NSHTTPURLResponse *httpResponse = nil;
	NSError *error = nil;
    self.request = request;
    
	if(![self connectionVerified])
		return [CKResult resultWithRequest:request andResponse:nil];	
        
	NSData *response = [NSURLConnection sendSynchronousRequest:[_request remoteRequest] returningResponse:&httpResponse error:&error];
    
	_responseCode = [httpResponse statusCode];
    self.responseHeaders = [httpResponse allHeaderFields];
    
	return [[CKResult alloc] initWithRequest:_request response:response httpResponse:httpResponse error:&error];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response{
	
	_responseCode = [response statusCode];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
	if(_request.parseBlock != nil){
        
        id object = [[CKManager sharedManager] parse:data];
        
        if(object != nil)
            _request.parseBlock(object);
    }
    
    [_responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    [[challenge sender] useCredential:[_request credentials] forAuthenticationChallenge:challenge];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    _request.failed = YES;
    _request.completed = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	CKResult *result = [CKResult resultWithRequest:_request andError:&error];
    	
	if(_request.errorBlock != nil)
        dispatch_async(dispatch_get_main_queue(), ^{
            _request.errorBlock(result);
        });
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	
    _request.completed = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	CKResult *result = [CKResult resultWithRequest:_request andResponse:_responseData];
    
	if(_request.completionBlock != nil)
        dispatch_async(dispatch_get_main_queue(), ^{
            _request.completionBlock(result);	
        });
}

@end
