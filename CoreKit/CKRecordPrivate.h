//
//  CKRecordPrivate.h
//  CoreKit
//
//  Created by Matt Newberry on 7/21/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecord.h"

@interface CKRecord (CKRecordPrivate)

- (NSPropertyDescription *) propertyDescriptionForKey:(NSString *) key;
- (void) setProperty:(NSString *) property value:(id) value attributeType:(NSAttributeType) attributeType;
- (void) setRelationship:(NSString *) relationship value:(id) value;

+ (NSNumber *) aggregateForKeyPath:(NSString *) keyPath;

@end
