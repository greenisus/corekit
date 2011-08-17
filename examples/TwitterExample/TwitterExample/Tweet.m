//
//  Tweet.m
//  TwitterExample
//
//  Created by Matt Newberry on 8/15/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "Tweet.h"
#import "CKRequest.h"


@implementation Tweet

@dynamic created_at;
@dynamic from_user;
@dynamic id;
@dynamic profile_image_url;
@dynamic text;

+ (void) search:(NSString *) query parseBlock:(CKParseBlock) parseBlock completionBlock:(CKResultBlock) completionBlock errorBlock:(CKErrorBlock) errorBlock{
    
    CKRequest *request = [Tweet requestForGet];
    request.parseBlock = parseBlock;
    request.completionBlock = completionBlock;
    request.errorBlock = errorBlock;
    request.batch = YES;
    [request addParameters:[NSDictionary dictionaryWithObject:query forKey:@"q"]];
    
    [request send];
}

@end
