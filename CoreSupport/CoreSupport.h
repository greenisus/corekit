//
//  CoreSupport.h
//  CoreSupport
//
//  Created by Matt Newberry on 8/23/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define $D(...) [NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil]
#define $A(...) [NSArray arrayWithObjects: __VA_ARGS__, nil]
#define $MA(...) [NSMutableArray arrayWithObjects: __VA_ARGS__, nil]
#define $S(format, ...) [NSString stringWithFormat:format, ## __VA_ARGS__]
#define $I(i) [NSNumber numberWithInt:i]
#define $B(b) [NSNumber numberWithBool:b]
#define $F(f) [NSNumber numberWithFloat:f]
#define toArray(object) (object != nil ? ([object isKindOfClass:[NSArray class]] ? object : [NSArray arrayWithObject:object]) : [NSArray array])
#define $P(...) [NSPredicate predicateWithFormat:__VA_ARGS__]
#define $SORT(i) [CoreSupport sortDescriptorsFromString:i]

@interface CoreSupport : NSObject

#pragma mark -
#pragma mark Sort Descriptors
+ (NSArray *) sortDescriptorsFromString:(NSString*)string;
+ (NSArray *) sortDescriptorsFromParameters:(id)parameters;

#pragma mark -
#pragma mark Predicates
+ (NSPredicate *) variablePredicateFromObject:(id)object;
+ (NSPredicate *) predicateFromObject:(id)object;
+ (NSPredicate *) equivalencyPredicateForKey:(NSString*)key;

@end
