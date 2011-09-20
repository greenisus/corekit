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
#import "NSString+InflectionSupport.h"

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
    
    self = [super init];
    if (self) {
        
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
    
    _responseBody = responseBody;
    
    if (responseBody != nil && [responseBody length] > 0){
        
         Class model = _request.routerMap.model;
        
        id parsed = [[CKManager sharedManager] parse:responseBody];
        
        NSString *pluralEntityName = [[[model entityNameWithPrefix:NO] lowercaseString] pluralForm];
                
        if([_request.routerMap.responseKeyPath length] > 0 && [parsed isKindOfClass:[NSDictionary class]])        
            parsed = [parsed objectForKeyPath:_request.routerMap.responseKeyPath];
        else if ([parsed isKindOfClass:[NSDictionary class]] && [[parsed allKeys] containsObject:pluralEntityName])
            parsed = [parsed objectForKey:pluralEntityName];
        
        id builtObjects;
        
        if(model != nil && parsed != nil)        
            builtObjects = [model build:parsed];
        
        self.objects = [builtObjects isKindOfClass:[NSArray class]] ? builtObjects : [NSArray arrayWithObject:builtObjects];
        
        [CKRecord save];
    }
    else
        self.objects = [NSArray array];
}

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len{
    
    return [_objects countByEnumeratingWithState:state objects:buffer count:len];
}


@end
