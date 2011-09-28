//
//  CoreSupport.m
//  CoreSupport
//
//  Created by Matt Newberry on 8/23/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "CoreSupport.h"

@implementation CoreSupport

#pragma mark -
#pragma mark Sort Descriptors
+ (NSArray *) sortDescriptorsFromString:(NSString*)string {
    NSMutableArray* sortDescriptors = nil;
	
    NSArray* sortChunks = [string componentsSeparatedByString:@" "];
    if ([sortChunks count] % 2 == 0) {
        sortDescriptors = [NSMutableArray arrayWithCapacity:[sortChunks count] / 2];
        for (int chunkIdx = 0; chunkIdx < [sortChunks count]; chunkIdx += 2) {
            [sortDescriptors addObject:
			 [[NSSortDescriptor alloc] initWithKey:[sortChunks objectAtIndex:chunkIdx] ascending:
			   [[sortChunks objectAtIndex:chunkIdx + 1] caseInsensitiveCompare:@"asc"] == NSOrderedSame]];
        }
    }
    return sortDescriptors;
}

+ (NSArray *) sortDescriptorsFromParameters:(id)parameters {
    if ([parameters isKindOfClass:[NSString class]])
        return [self sortDescriptorsFromString:parameters];
    if ([parameters isKindOfClass:[NSDictionary class]])
        return [self sortDescriptorsFromParameters:[parameters objectForKey:@"$sort"]];
    else if ([parameters isKindOfClass:[NSArray class]])
        return parameters;
    return nil;
}



#pragma mark -
#pragma mark Predicates
+ (NSPredicate *) predicateFromObject:(id)object {
    return object != nil ? [[self variablePredicateFromObject:object] predicateWithSubstitutionVariables:object] : nil;
}

+ (NSPredicate *) variablePredicateFromObject:(id)object {
    if (object != nil) {
        if ([object isKindOfClass:[NSPredicate class]])
            return object;
		
        if ([object isKindOfClass:[NSString class]])
            return [NSPredicate predicateWithFormat:(NSString*)object];
		
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *predicates = [NSMutableArray arrayWithCapacity:[object count]];
            for (NSString *key in object) {
                if (![key hasPrefix:@"$"])
                    [predicates addObject:[self equivalencyPredicateForKey:key]];
            }
            
            return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        }
		
		if([object isKindOfClass:[NSNumber class]])
			return [NSPredicate predicateWithFormat:@"id = %i", object];
    }
	
    return [NSPredicate predicateWithValue:YES];
}

+ (NSPredicate*) equivalencyPredicateForKey:(NSString*)key {
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:key] 
											  rightExpression:[NSExpression expressionForVariable:key]
													 modifier:NSDirectPredicateModifier 
														 type:NSEqualToPredicateOperatorType 
													  options:0];
}

@end
