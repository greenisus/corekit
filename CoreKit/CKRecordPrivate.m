//
//  CKRecordPrivate.m
//  CoreKit
//
//  Created by Matt Newberry on 7/21/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecordPrivate.h"

@implementation CKRecord (CKRecordPrivate)

- (NSPropertyDescription *) propertyDescriptionForKey:(NSString *) key{
    
    if(_attributes == nil)
        _attributes = [[[[self class] entityDescription] propertiesByName] retain];
    
    return [[_attributes allKeys] containsObject:key] ? [_attributes objectForKey:key] : nil;
}

- (void) setProperty:(NSString *) property value:(id) value attributeType:(NSAttributeType) attributeType{
        
    if(value != nil){
        
        switch (attributeType) {
                
            case NSDateAttributeType:
                if(![value isKindOfClass:[NSDate class]] && [value isKindOfClass:[NSString class]]){
                 
                    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
                    [formatter setDateFormat:[[self class] dateFormat]];
                    value = [formatter dateFromString:value];
                }
                else
                    value = nil;
                
                break;
                
            case NSStringAttributeType:
                if(![value isKindOfClass:[NSString class]])
                    value = nil;
                break;
                
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType:
                value = [NSNumber numberWithInt:[value intValue]];
                break;
                
            case NSFloatAttributeType:
            case NSDecimalAttributeType:
                value = [NSNumber numberWithFloat:[value floatValue]];
                break;
                
            case NSDoubleAttributeType:
                value = [NSNumber numberWithDouble:[value doubleValue]];
                break;
                
            case NSBooleanAttributeType:
                value = [NSNumber numberWithBool:[value boolValue]];
                break;
        }
    }
    
    [self setValue:value forKey:property];
}

- (void) setRelationship:(NSString *) relationship value:(id) value{
    
}

+ (NSNumber *) aggregateForKeyPath:(NSString *) keyPath{
    
    NSArray *results = [[self class] all];
    
    return [results valueForKeyPath:keyPath];
}

@end
