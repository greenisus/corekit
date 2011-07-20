//
//  CKRequestQueue.h
//  CoreKit
//
//  Created by Matt Newberry on 7/19/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRequest.h"

@interface CKRequestQueue : NSObject{
    
    NSMutableArray *_requests;
    BOOL _suspended;
    
    NSUInteger _requestLimit;
    NSUInteger _connectionTimeout;
}

- (void) addRequest:(CKRequest *) request;
- (void) cancelRequest:(CKRequest *) request;
- (void) cancelAllRequests;
- (void) suspend;
- (void) start;

- (void) nextRequest;

@end
