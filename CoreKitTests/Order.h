//
//  Order.h
//  ObjectiveRecord
//
//  Created by Matthew Newberry on 8/5/10.
//  Copyright 2010 Jaded Pixel Technologies Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CKRecord.h"

@class OrderItem;

@interface Order : CKRecord  
{
}

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSSet* items;

@end


@interface Order (CoreDataGeneratedAccessors)
- (void)addItemsObject:(OrderItem *)value;
- (void)removeItemsObject:(OrderItem *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end

