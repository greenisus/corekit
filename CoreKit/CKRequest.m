//
//  CKRequest.m
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRequest.h"

@implementation CKRequest

- (id)init {

    if (self = [super init]) {
        
        _interval = CKRequestIntervalNone;
    }
    
    return self;
}


@end
