//
//  CKSupport.m
//  CoreKit
//
//  Created by Matt Newberry on 7/28/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKSupport.h"
#import "Reachability.h"


NSArray* CK_SORT(NSString *sort){
    
    NSMutableArray* sortDescriptors = nil;
	
    NSArray* sortChunks = [sort componentsSeparatedByString:@" "];
    
    if ([sortChunks count] % 2 == 0) {
        
        sortDescriptors = [NSMutableArray arrayWithCapacity:[sortChunks count] / 2];
        
        for (int chunkIdx = 0; chunkIdx < [sortChunks count]; chunkIdx += 2) {
            
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:[sortChunks objectAtIndex:chunkIdx] ascending:
			   [[sortChunks objectAtIndex:chunkIdx + 1] caseInsensitiveCompare:@"asc"] == NSOrderedSame]];
        }
    }
    
    return sortDescriptors;
}

BOOL CK_CONNECTION_AVAILABLE(void){
    
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
}
