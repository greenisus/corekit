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

+ (void) search:(NSString *) query parseBlock:(CKParseBlock) parseBlock completionBlock:(CKResultBlock) completionBlock errorBlock:(CKResultBlock) errorBlock{
    
    CKRequest *request = [Tweet requestForGet];
    request.parseBlock = parseBlock;
    request.completionBlock = completionBlock;
    request.errorBlock = errorBlock;
    request.batch = YES;
    [request addParameters:[NSDictionary dictionaryWithObject:query forKey:@"q"]];
    
    [request send];
}

- (NSString *) relativeDate{
        
    NSTimeInterval interval = abs([self.created_at timeIntervalSinceNow]);
    NSString *dateString = nil;
    
    if (interval < 60) {
        dateString = [NSString stringWithFormat:@"%is", interval];
        
    } else if (interval < 3600) {
        int mins = (int)(interval / 60);
        dateString =  [NSString stringWithFormat:@"%dm", mins];
        
    } else if (interval < 86400) {
        int hours = (int)((interval + 3600 / 2) / 3600);
        dateString =  [NSString stringWithFormat:@"%dh", hours];
        
    } else if (interval < 604800) {
        int day = (int)((interval + 86400 / 2) / 86400);
        dateString =  [NSString stringWithFormat:@"%dd", day];
    }
    
    return dateString;
}

@end
