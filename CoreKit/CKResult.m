//
//  CKResult.m
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKResult.h"
#import "CKDefines.h"

@implementation CKResult

@synthesize objects = _objects;
@synthesize error = _error;
@synthesize httpResponse = _httpResponse;
@synthesize request = _request;

- (id) initWithRequest:(CKRequest *) request objects:(NSArray *) objects httpResponse:(NSHTTPURLResponse *) httpResponse error:(NSError **) error{
    
    if(self = [super init]){
        
        self.request = request;
        self.objects = objects;
        self.httpResponse = httpResponse;
        self.error = *error;
    }
    
    return self;
}

- (id) initWithObjects:(NSArray *) objects{
    
    return [self initWithRequest:nil objects:objects httpResponse:nil error:nil];
}

- (void) dealloc{
    
    RELEASE_SAFELY(_objects);
    RELEASE_SAFELY(_error);
    RELEASE_SAFELY(_httpResponse);
    RELEASE_SAFELY(_request);
    
    [super dealloc];
}

@end
