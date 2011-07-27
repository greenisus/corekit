//
//  CKSearch.m
//  CoreKit
//
//  Created by Matt Newberry on 7/26/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKSearch.h"

@implementation CKSearch

@synthesize query = _query;
@synthesize sortBy = _sortBy;
@synthesize entity = _entity;
@synthesize propertiesToFetch = _propertiesToFetch;
@synthesize limit = _limit;
@synthesize batchSize = _batchSize;
@synthesize offset = _offset;

- (id)init {
    
    if (self = [super init]) {
        
        self.limit = 0;
        self.batchSize = 25;
        self.uniqueValuesOnly = NO;
    }
    
    return self;
}

- (NSArray *) search{
    
}

- (NSPredicate *) predicate{
    
}

@end
