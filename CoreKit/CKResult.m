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
    
    if([response isKindOfClass:[NSArray class]] && [[response objectAtIndex:0] isKindOfClass:[NSManagedObject class]])
        self.objects = response;
    
    else{
        
        id parsed = [[CKManager sharedManager] parse:response];
        
        if([_request.routerMap.responseKeyPath length] > 0 && [parsed isKindOfClass:[NSDictionary class]])        
            parsed = [parsed objectForKeyPath:_request.routerMap.responseKeyPath];
        
        Class model = _request.routerMap.model;
        
        if(model != nil && parsed != nil)        
            parsed = [model build:parsed];
        
        [CKRecord save];
        
        NSArray *parsedObjects = [parsed isKindOfClass:[NSArray class]] ? parsed : [NSArray arrayWithObject:parsed];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *safeObjects = [NSMutableArray arrayWithCapacity:[parsedObjects count]];
            
            for(id obj in parsedObjects)
                [obj isKindOfClass:[NSManagedObject class]] ? [safeObjects addObject:[[CKManager sharedManager].managedObjectContext objectWithID:[obj objectID]]] : [safeObjects addObject:obj];
            
            self.objects = safeObjects;
        });
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
