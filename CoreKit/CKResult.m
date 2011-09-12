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
@synthesize httpResponse = _httpResponse;
@synthesize request = _request;
@synthesize response = _response;

+ (CKResult *) resultWithRequest:(CKRequest *) request andResponse:(id) response{

    return [[self alloc] initWithRequest:request response:response httpResponse:nil error:nil];
}

+ (CKResult *) resultWithRequest:(CKRequest *) request andError:(NSError **) error{
 
    return [[self alloc] initWithRequest:request response:nil httpResponse:nil error:error];
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
    
    if([response isKindOfClass:[NSData class]] && [response length] == 0)
        self.objects = [NSArray array];
    
    else if(response != nil && [response isKindOfClass:[NSArray class]] && [[response objectAtIndex:0] isKindOfClass:[NSManagedObject class]])
        self.objects = response;
    
    else if (response != nil){
        
        id parsed = [[CKManager sharedManager] parse:response];
        
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
