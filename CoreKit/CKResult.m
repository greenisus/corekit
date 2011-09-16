//
//  CKResult.m
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKResult.h"
#import "CKDefines.h"
#import "CKManager.h"
#import "CKRecord.h"
#import "CKRouterMap.h"
#import "NSDictionary+NSDictionary_KeyPath.h"

@implementation CKResult

@synthesize objects = _objects;
@synthesize error = _error;
@synthesize request = _request;
@synthesize responseBody = _responseBody;
@synthesize responseHeaders = _responseHeaders;
@synthesize responseCode = _responseCode;

+ (CKResult *) resultWithRequest:(CKRequest *) request andResponseBody:(NSData *) responseBody{

    return [[self alloc] initWithRequest:request responseBody:responseBody httpResponse:nil error:nil];
}

+ (CKResult *) resultWithRequest:(CKRequest *) request andError:(NSError **) error{
 
    return [[self alloc] initWithRequest:request responseBody:nil httpResponse:nil error:error];
}

- (id) initWithRequest:(CKRequest *) request responseBody:(NSData *) responseBody httpResponse:(NSHTTPURLResponse *) httpResponse error:(NSError **) error{
    
    if(self = [super init]){
        
        self.request = request;
        self.responseBody = responseBody;
        
        if(httpResponse != nil){
            
            _responseCode = [httpResponse statusCode];
            self.responseHeaders = [httpResponse allHeaderFields];
        }
        
        if(error != nil)
            self.error = *error;
    }
    
    return self;
}

- (id) initWithObjects:(NSArray *) objects{
    
    id init = [self initWithRequest:nil responseBody:nil httpResponse:nil error:nil];
    self.objects = objects;
    
    return init;
}

- (id) object{
	
	return _objects != nil && [_objects count] > 0 ? [_objects objectAtIndex:0] : nil;
}

- (void) setResponseBody:(NSData *)responseBody{
    
    //if([response isKindOfClass:[NSData class]] && [response length] == 0)
    //  self.objects = [NSArray array];
    
    // else if(response != nil && [response isKindOfClass:[NSArray class]] && [[response objectAtIndex:0] isKindOfClass:[NSManagedObject class]])
    //    self.objects = response;
    
    _responseBody = responseBody;
    
    if (responseBody != nil){
        
        id parsed = [[CKManager sharedManager] parse:responseBody];
        
        if([_request.routerMap.responseKeyPath length] > 0 && [parsed isKindOfClass:[NSDictionary class]])        
            parsed = [parsed objectForKeyPath:_request.routerMap.responseKeyPath];
        
        Class model = _request.routerMap.model;
        
        if(model != nil && parsed != nil)        
            parsed = [model build:parsed];
        
        self.objects = [parsed isKindOfClass:[NSArray class]] ? parsed : [NSArray arrayWithObject:parsed];
        [CKRecord save];
    }
    else
        self.objects = [NSArray array];
}

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len{
    
    return [_objects countByEnumeratingWithState:state objects:buffer count:len];
}


@end
