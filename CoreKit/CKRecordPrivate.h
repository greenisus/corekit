//
//  CKRecordPrivate.h
//  CoreKit
//
//  Created by Matt Newberry on 7/21/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecord.h"

@interface CKRecord (CKRecordPrivate)

+ (NSManagedObjectContext *) managedObjectContext;

- (NSPropertyDescription *) propertyDescriptionForKey:(NSString *) key;
- (void) setProperty:(NSString *) property value:(id) value attributeType:(NSAttributeType) attributeType;
- (void) setRelationship:(NSString *) key value:(id) value relationshipDescription:(NSRelationshipDescription *) relationshipDescription;

+ (NSNumber *) aggregateForKeyPath:(NSString *) keyPath;

@end
