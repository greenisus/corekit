//
//  CKSearch.h
//  CoreKit
//
//  Created by Matt Newberry on 7/26/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKSearch : NSObject{
    
    NSString *_query;
    NSString *_sortBy;
    NSEntityDescription *_entity;
    NSArray *_propertiesToFetch;
    
    NSUInteger _limit;
    NSUInteger _batchSize;
    NSUInteger _offset;
    
    BOOL _uniqueValuesOnly;
}

@property (nonatomic, retain) NSString *query;
@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSEntityDescription *entity;
@property (nonatomic, retain) NSArray *propertiesToFetch;
@property (nonatomic, assign) NSUInteger limit;
@property (nonatomic, assign) NSUInteger batchSize;
@property (nonatomic, assign) NSUInteger offset;
@property (nonatomic, assign) BOOL uniqueValuesOnly;

- (NSArray *) search;
- (NSPredicate *) predicate;

@end
