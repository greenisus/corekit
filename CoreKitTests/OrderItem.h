//
//  OrderItem.h
//  ObjectiveRecord
//
//  Created by Matthew Newberry on 8/5/10.
//  Copyright 2010 Jaded Pixel Technologies Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CKRecord.h"

@class Order;

@interface OrderItem : CKRecord  
{
}

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSNumber * qty;
@property (nonatomic, strong) Order * order;

@end



