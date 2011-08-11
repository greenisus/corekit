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


@implementation CKNSURLConnection

@synthesize responseCode = _responseCode;
@synthesize responseData = _responseData;
@synthesize request = _request;

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
    
    if(![self connectionVerified])
		return;
    
    self.request = request;
    
    if(request.batch && !request.isBatched)
        [self sendBatch];
    
    else{
                
        NSURLConnection *connection = [[NSURLConnection	alloc] initWithRequest:[_request remoteRequest] delegate:self startImmediately:NO];
        self.request.connection = connection;
        
        [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [connection start];
        
        while (!_request.completed && !_request.failed) {			
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate dateWithTimeIntervalSinceNow:_request.connectionTimeout]];
        }
        
        [connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        RELEASE_SAFELY(connection);
    }
}

- (void) sendBatch{
    
    for(int page = 1; page <= _request.batchMaxPages; page++){
        
//        CKRequest *pagedRequest = [_request copy];
//        pagedRequest.isBatched = YES;
//        
//        [pagedRequest addParameters:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%i", page] forKey:pagedRequest.batchPageString]];
//        
//        CKNSURLConnection *connection = [[CKNSURLConnection alloc] init];
//        [connection send:pagedRequest];
//        
//        [pagedRequest release];
    }
    
}

- (CKResult *) sendSyncronously:(CKRequest *) request{
	
    NSHTTPURLResponse *httpResponse = nil;
	NSError *error = nil;
    self.request = request;
    
	if(![self connectionVerified])
		return [CKResult resultWithRequest:request andResponse:nil];	
        
	NSData *response = [NSURLConnection sendSynchronousRequest:[_request remoteRequest] returningResponse:&httpResponse error:&error];
    
	_responseCode = [httpResponse statusCode];
    
	return [[[CKResult alloc] initWithRequest:_request response:response httpResponse:httpResponse error:&error]autorelease];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response{
	
	_responseCode = [response statusCode];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
	if(_request.parseBlock != nil){
        
        id object = [[CKManager sharedManager] parse:data];
        
        if(object != nil)
            _request.parseBlock(_request, object);
    }
    
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    [[challenge sender] useCredential:[_request credentials] forAuthenticationChallenge:challenge];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    _request.failed = YES;
	
	CKResult *result = [CKResult resultWithRequest:_request andError:&error];
    	
	if(_request.errorBlock)
		_request.errorBlock(result, &error);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	
    _request.completed = YES;
    
	CKResult *result = [CKResult resultWithRequest:_request andResponse:_responseData];
    
	if(_request.completionBlock && _responseCode < 500)
		_request.completionBlock(result);	
}

- (void) dealloc{
    
    RELEASE_SAFELY(_responseData);
    RELEASE_SAFELY(_request);
    
    [super dealloc];
}

@end
