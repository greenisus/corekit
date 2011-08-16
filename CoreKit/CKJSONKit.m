//
//  CKJSONKit.m
//  CoreKit
//
//  Created by Matt Newberry on 8/15/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKJSONKit.h"
#import "JSONKit.h"

@implementation CKJSONKit

- (id) deserialize:(NSData *) data{
    
    return [[JSONDecoder decoder] objectWithData:data];
}

- (id) serialize:(id) object{
    
    return [object JSONString];
}

@end
