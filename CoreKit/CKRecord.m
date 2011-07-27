//
//  CKRecord.m
//  CoreKit
//
//  Created by Matt Newberry on 7/19/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecord.h"
#import "CKManager.h"
#import "CKDefines.h"
#import "NIPaths.h"
#import "CKCoreData.h"
#import "CKRecordPrivate.h"
#import "CKResult.h"

@implementation CKRecord

@synthesize attributes = _attributes;

- (id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context{
    
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]){
        
        _attributes = [[[[self class] entityDescription] propertiesByName] retain];
    }
    
    return self;
}

- (void) dealloc{
    
    RELEASE_SAFELY(_attributes);
    [super dealloc];
}

#pragma mark -
#pragma mark Entity Methods

+ (NSString *) entityName {
	
	return [self entityNameWithPrefix:YES];
}

+ (NSString *) entityNameWithPrefix:(BOOL) removePrefix{
    
    NSMutableString *name = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", self]];

    if([ckCoreDataClassPrefix length] > 0 && removePrefix)
        [name replaceOccurrencesOfString:ckCoreDataClassPrefix withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ckCoreDataClassPrefix length])];
	
	return name;
}

+ (NSEntityDescription *) entityDescription{
	
	return [NSEntityDescription entityForName:[self entityNameWithPrefix:NO] inManagedObjectContext:[self managedObjectContext]];
}

+ (NSFetchRequest *) fetchRequest{
	
	NSFetchRequest *fetch = [[[NSFetchRequest alloc] init] autorelease];
	[fetch setEntity:[self entityDescription]];
	return fetch;
}


#pragma mark -
#pragma mark Saving
+ (BOOL) save{
        
    return [[[CKManager sharedManager] coreData] save];
}

#pragma mark -
#pragma mark Creating, Updating, Deleting

+ (id) blank{
    
    return [[[self alloc] initWithEntity:[self entityDescription] insertIntoManagedObjectContext:[self managedObjectContext]] autorelease];
}

+ (id) build:(id) data{
    
    __block id returnValue = nil;
    
    if ([data isKindOfClass:[NSArray class]]) {
        
        returnValue = [NSMutableArray arrayWithCapacity:[data count]];
        
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
           
            id object = [self build:obj];
            
            if(object != nil)
                [returnValue addObject:object];
        }];
    }
    
    else if ([data isKindOfClass:[NSDictionary class]]) {
        
        id resourceId = [data objectForKey:[self primaryKeyName]];
        
		if (resourceId != nil){
			
			id resource = [self findById:[NSNumber numberWithInt:[resourceId intValue]]];
            
            returnValue = resource == nil ? [self create:data] : [resource update:data];
		}
		else
			returnValue = [self create:data];
    }
        
    return returnValue;
}

+ (id) create:(id) data{
    
    __block id returnValue = nil;
    
    if([data isKindOfClass:[NSDictionary class]])
        returnValue = [[self blank] update:data];
    else if([data isKindOfClass:[NSArray class]]){
        
        returnValue = [NSMutableArray array];
        
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            id newValue = [self create:obj];

            if(newValue != nil)
                [returnValue addObject:newValue]; 
        }];
    }
    
    return returnValue;
}

- (id) update:(NSDictionary *) data{
        
    [data enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop){
        
        NSDictionary *propertyMap = [[self class] attributeMap];
        NSString *localKey = [[propertyMap allKeys] containsObject:key] ? [propertyMap objectForKey:key] : key;  
        
        NSPropertyDescription *propertyDescription = [self propertyDescriptionForKey:localKey];
        
        if(propertyDescription != nil){
            
            if([propertyDescription isKindOfClass:[NSRelationshipDescription class]])
                [self setRelationship:localKey value:obj relationshipDescription:(NSRelationshipDescription *) propertyDescription];
            else if([propertyDescription isKindOfClass:[NSAttributeDescription class]]){
                
                NSAttributeDescription *attributeDescription = (NSAttributeDescription *) propertyDescription;
                [self setProperty:localKey value:obj attributeType:[attributeDescription attributeType]];
            }
        }
    }];
    
    return self;
}

+ (void) updateWithPredicate:(NSPredicate *)predicate withData:(NSDictionary *)data{
 
    [[self findWithPredicate:predicate] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
       
        [obj update:data];
    }];
}

+ (void) removeAll{
    
	[self removeAllWithPredicate:nil];
}

+ (void) removeAllWithPredicate:(NSPredicate *) predicate{
	
	NSFetchRequest *request = [self fetchRequest];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
       
        [obj remove];
    }];
}

- (void) remove{
	
	[[self managedObjectContext] deleteObject:self];
}

#pragma mark -
#pragma mark Counting

+ (NSUInteger) count{
	
	return [self countWithPredicate:nil];
}

+ (NSUInteger) countWithPredicate:(NSPredicate *) predicate{
	
	NSFetchRequest *fetch = [self fetchRequest];
	[fetch setPredicate:predicate];
	
	return [[self managedObjectContext] countForFetchRequest:fetch error:nil];
}

#pragma mark -
#pragma mark Searching

+ (id) first{
    
    NSArray *results = [self findWithPredicate:nil sortedBy:nil withLimit:1];
    
    return [results count] == 1 ? [results objectAtIndex:0] : nil;
}

+ (id) last{
    
    NSArray *results = [self all];
    
    return [results count] > 0 ? [results lastObject] : nil;
}

+ (BOOL) exists:(NSNumber *)itemID{
    
    id result = [self findById:itemID];
    
    return result == nil;
}

+ (NSArray *) all{
    
    return [self allSortedBy:nil];
}

+ (NSArray *) allSortedBy:(NSString *)sortBy{
    
    return [self findWithPredicate:nil sortedBy:sortBy withLimit:0];
}

+ (NSArray *) findWithPredicate:(NSPredicate *)predicate{
    
    return [self findWithPredicate:predicate sortedBy:nil withLimit:0];
}

+ (NSArray *) findWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortedBy withLimit:(NSUInteger)limit{
    
    NSFetchRequest *request = [self fetchRequest];
    [request setPredicate:predicate];
    
    if(limit > 0)
        [request setFetchLimit:limit];
    
    return [[self managedObjectContext] executeFetchRequest:request error:nil];
}

+ (NSArray *) findWhereAttribute:(NSString *)attribute contains:(id)value{
    
    return [self findWithPredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS %@", attribute, value]];
}

+ (NSArray *) findWhereAttribute:(NSString *)attribute equals:(id)value{
    
    return [self findWithPredicate:[NSPredicate predicateWithFormat:@"%K == %@", attribute, value]];
}

+ (id) findById:(NSNumber *) itemId{
        
    NSArray *results = [self findWithPredicate:[NSPredicate predicateWithFormat:@"%K == %i", [self primaryKeyName], [itemId intValue]] sortedBy:nil withLimit:1];
    
    return [results count] > 0 ? [results objectAtIndex:0] : nil;
}


#pragma mark -
#pragma mark Aggregates

+ (NSNumber *) average:(NSString *)attribute{
    
    return [self aggregateForKeyPath:[NSString stringWithFormat:@"@avg.%@", attribute]];
}

+ (NSNumber *) minimum:(NSString *)attribute{
    
    return [self aggregateForKeyPath:[NSString stringWithFormat:@"min.%@", attribute]];
}

+ (NSNumber *) maximum:(NSString *)attribute{
    
    return [self aggregateForKeyPath:[NSString stringWithFormat:@"max.%@", attribute]];
}

+ (NSNumber *) sum:(NSString *)attribute{
    
    return [self aggregateForKeyPath:[NSString stringWithFormat:@"@sum.%@", attribute]];
}

#pragma mark -
#pragma mark Fixtures

+ (id) fixtureNamed:(NSString *) name{
    
    return [self fixtureNamed:name atPath:nil];
}

+ (id) fixtures{
    
    return [self fixtureNamed:nil atPath:nil];
}

+ (NSArray *) fixturesAsArray{
        
    return [[self fixtures] allValues];
}

+ (id) fixtureNamed:(NSString *) name atPath:(NSString *) path{
    
    NSString *fixturePath = NIPathForBundleResource([NSBundle bundleForClass:[self class]], ckFixturePath);

    if(path == nil){
        
        NSError *error;
        
        NSArray *fixtures = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fixturePath error:&error];
        NSArray *classFiles = [fixtures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH %@", [self entityNameWithPrefix:NO]]];
        
        if([classFiles count] > 0)
            fixturePath = [fixturePath stringByAppendingFormat:@"/%@", [classFiles objectAtIndex:0]];
    }
    else
        fixturePath = [fixturePath stringByAppendingFormat:@"/%@", path];
    
    id contents = [[CKManager sharedManager] parse:[NSData dataWithContentsOfFile:fixturePath]];
    
    if([contents isKindOfClass:[NSDictionary class]] && name != nil && [[contents allKeys] containsObject:name])
        contents = [contents objectForKey:name];
    
    return contents;
}


#pragma mark -
#pragma mark Defaults

+ (NSString *) dateFormat{
    
    return ckDateDefaultFormat;
}

+ (NSDictionary *) attributeMap{
    
    return [NSDictionary dictionary];
}

+ (NSString *) primaryKeyName{
    
    return @"id";
}


@end
