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
#import "NSDictionary+NSDictionary_KeyPath.h"

@implementation CKResult

@synthesize objects = _objects;
@synthesize error = _error;
@synthesize httpResponse = _httpResponse;
@synthesize request = _request;
@synthesize response = _response;

+ (CKResult *) resultWithRequest:(CKRequest *) request andResponse:(id) response{

    return [[[self alloc] initWithRequest:request response:response httpResponse:nil error:nil] autorelease];
}

+ (CKResult *) resultWithRequest:(CKRequest *) request andError:(NSError **) error{
 
    return [[[self alloc] initWithRequest:request response:nil httpResponse:nil error:error] autorelease];
}

- (id) initWithRequest:(CKRequest *) request response:(id) response httpResponse:(NSHTTPURLResponse *) httpResponse error:(NSError **) error{
    
    if(self = [super init]){
        
        self.request = request;
        self.response = response;
        self.httpResponse = httpResponse;
        
        if(error != nil)
            self.error = *error;
    }
    
    return self;
}

- (id) initWithObjects:(NSArray *) objects{
    
    return [self initWithRequest:nil response:objects httpResponse:nil error:nil];
}

- (id) object{
	
	return _objects != nil && [_objects count] > 0 ? [_objects objectAtIndex:0] : nil;
}

- (void) setResponse:(id) response{
    
    id parsedResponse = [[CKManager sharedManager] parse:response];
    
    if([_request.routerMap.responseKeyPath length] > 0 && [parsedResponse isKindOfClass:[NSDictionary class]])        
        parsedResponse = [parsedResponse objectForKeyPath:_request.routerMap.responseKeyPath];
    
    if([parsedResponse isKindOfClass:[NSArray class]])
		[self setObjects:parsedResponse];
    
	else if([parsedResponse isKindOfClass:[NSDictionary class]]){
		
		id rootObject = [parsedResponse objectForKey:[[parsedResponse allKeys] objectAtIndex:0]];
		
		if([rootObject isKindOfClass:[NSDictionary class]])
			[self setObjects:[NSArray arrayWithObject:rootObject]];
		else if([rootObject isKindOfClass:[NSArray class]])
			[self setObjects:rootObject];
		else
			[self setObjects:[NSArray arrayWithObject:parsedResponse]];
	}
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(id*)stackbuf count:(NSUInteger)len {
    return [_objects countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (void) dealloc{
    
    RELEASE_SAFELY(_objects);
    RELEASE_SAFELY(_error);
    RELEASE_SAFELY(_httpResponse);
    RELEASE_SAFELY(_request);
    
    [super dealloc];
}

@end
