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
#import "CKSupport.h"
#import "CKCoreData.h"
#import "CKRecordPrivate.h"
#import "CKResult.h"
#import "CKRecord+CKRouter.h"
#import "NSString+InflectionSupport.h"

@implementation CKRecord

@synthesize attributes = _attributes;

- (id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context{
    
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self) {        
        _attributes = [[[self class] entityDescription] propertiesByName];
    }
    
    return self;
}

#pragma mark -
#pragma mark Entity Methods

+ (NSString *) entityName {
	
	return [self entityNameWithPrefix:YES];
}

+ (NSString *) entityNameWithPrefix:(BOOL) includePrefix{
    
    NSMutableString *name = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", self]];

    if([ckCoreDataClassPrefix length] > 0 && !includePrefix)
        [name replaceOccurrencesOfString:ckCoreDataClassPrefix withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ckCoreDataClassPrefix length])];
	
	return name;
}

+ (NSEntityDescription *) entityDescription{
	
	return [NSEntityDescription entityForName:[self entityNameWithPrefix:YES] inManagedObjectContext:[self managedObjectContext]];
}

+ (NSFetchRequest *) fetchRequest{
	
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	[fetch setEntity:[self entityDescription]];
    [fetch setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:[self primaryKeyName] ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetch setSortDescriptors:sortDescriptors];
    
	return fetch;
}


#pragma mark -
#pragma mark Saving
+ (BOOL) save{
        
    return [[[CKManager sharedManager] coreData] save];
}

- (BOOL) save{
    
    return [[self class] save];
}

#pragma mark -
#pragma mark Creating, Updating, Deleting

+ (id) blank{
    
    return [[self alloc] initWithEntity:[self entityDescription] insertIntoManagedObjectContext:[self managedObjectContext]];
}

+ (id) build:(id) data{
    
    __unsafe_unretained id returnValue = nil;
    
    if ([data isKindOfClass:[NSArray class]]) {
        
        returnValue = [NSMutableArray arrayWithCapacity:[data count]];
        
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
           
            id object = [self build:obj];
            
            if(object != nil)
                [returnValue addObject:object];
        }];
    }
    
    else if ([data isKindOfClass:[NSDictionary class]]) {
        
        // there are three common possibilities for dictionary response bodies:
        // 1. the dictionary represents a single entity
        //    example: { "id": 1, "name": "Mike" }
        // 2. the dictionary is single keyed where the key represents the entity id
        //    and the value is the entity
        //    example: { "1": { "name": "Mike" } }
        // 3. the dictionary is single keyed where the key represents an array of entities
        //    example: { "people": [{ "id": 1, "name": "Mike" }, { "id": 2, "name": "Matt" }] }
        
        id resourceId = [data objectForKey:[self primaryKeyName]];
        
        NSString *resourceName = [[[self entityNameWithPrefix:NO] pluralForm] lowercaseString];
        id resourceCollection = [data objectForKey:resourceName];
        
		if (resourceId != nil) {
			
			id resource = [self findById:[NSNumber numberWithInt:[resourceId intValue]]];
            
            returnValue = resource == nil ? [self create:data] : [[resource threadedSafeSelf] update:data];
        } else if (resourceCollection != nil) {
            
            // call recursively with the collection of entities
            returnValue = [self build:resourceCollection];
		} else {
			returnValue = [self create:data];
        }
    }
        
    return returnValue;
}

+ (id) create:(id) data{
    
    __autoreleasing id returnValue = nil;
    
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
        
    CKRecord *safe = [self threadedSafeSelf];
    
    [data enumerateKeysAndObjectsWithOptions:0 usingBlock:^(id key, id obj, BOOL *stop){
        
        NSDictionary *propertyMap = [[safe class] attributeMap];
        NSString *localKey = [[propertyMap allKeys] containsObject:key] ? [propertyMap objectForKey:key] : key;  
        
        NSPropertyDescription *propertyDescription = [safe propertyDescriptionForKey:localKey];
        
        if(propertyDescription != nil){
            
            if([propertyDescription isKindOfClass:[NSRelationshipDescription class]])
                [safe setRelationship:localKey value:obj relationshipDescription:(NSRelationshipDescription *) propertyDescription];
            else if([propertyDescription isKindOfClass:[NSAttributeDescription class]]){
                
                NSAttributeDescription *attributeDescription = (NSAttributeDescription *) propertyDescription;
                [safe setProperty:localKey value:obj attributeType:[attributeDescription attributeType]];
            }
        }
    }];
    
    NSError *error = nil;
    if(![safe validateForUpdate:&error]){
        NSLog(@"%@", error);
    }
    
    return safe;
}

+ (void) updateWithPredicate:(NSPredicate *)predicate withData:(NSDictionary *)data{
 
    [[self findWithPredicate:predicate] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
       
        [obj update:data];
    }];
}

+ (void) removeAll{
    
	[self removeAllWithPredicate:nil];
}

+ (void) removeAllInSet:(NSSet *) set{
    
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        
        [obj remove];
    }];
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

- (void) removeLocallyAndRemotely{
    
    [self remove];
    [self removeRemotely:nil errorBlock:nil];
}

#pragma mark -
#pragma mark Remote Syncronization
+ (void) get:(CKParseBlock) parseBlock completionBlock:(CKResultBlock) completionBlock errorBlock:(CKResultBlock) errorBlock{
    
    CKRequest *request = [self requestForGet];
    request.parseBlock = parseBlock;
    request.completionBlock = completionBlock;
    request.errorBlock = errorBlock;
    
    [[CKManager sharedManager] sendRequest:request];    
}

+ (CKRequest *) requestForGet{
    
    return [CKRequest requestWithMap:[self mapForRequestMethod:CKRequestMethodGET]];
}

- (void) post:(CKParseBlock) parseBlock completionBlock:(CKResultBlock) completionBlock errorBlock:(CKResultBlock) errorBlock{
    
    [self sync:[self requestForPost] parseBlock:parseBlock completionBlock:completionBlock errorBlock:errorBlock];
}

- (CKRequest *) requestForPost{
    
    CKRequest *request = [CKRequest requestWithMap:[self mapForRequestMethod:CKRequestMethodPOST]];
    request.body = [self serialize];
    
    return request;    
}

- (void) put:(CKParseBlock) parseBlock completionBlock:(CKResultBlock) completionBlock errorBlock:(CKResultBlock) errorBlock{
        
    [self sync:[self requestForPut] parseBlock:parseBlock completionBlock:completionBlock errorBlock:errorBlock];
}

- (CKRequest *) requestForPut{
    
    CKRequest *request = [CKRequest requestWithMap:[self mapForRequestMethod:CKRequestMethodPUT]];
    request.body = [self serialize];
    
    return request;
}

- (void) get:(CKParseBlock) parseBlock completionBlock:(CKResultBlock) completionBlock errorBlock:(CKResultBlock) errorBlock{
        
    [self sync:[self requestForGet] parseBlock:parseBlock completionBlock:completionBlock errorBlock:errorBlock];
}

- (CKRequest *) requestForGet{
    
    return [CKRequest requestWithMap:[self mapForRequestMethod:CKRequestMethodGET]];
}

- (void) removeRemotely:(CKResultBlock) completionBlock errorBlock:(CKResultBlock) errorBlock{
    
   [self sync:[self requestForRemoveRemotely] parseBlock:nil completionBlock:completionBlock errorBlock:errorBlock];
}

- (CKRequest *) requestForRemoveRemotely{
    
    return [CKRequest requestWithMap:[self mapForRequestMethod:CKRequestMethodDELETE]];
}

- (void) sync{
    
    if(![self isInserted])
        [self put:nil completionBlock:nil errorBlock:nil];
    
    else if([self isUpdated])
        [self post:nil completionBlock:nil errorBlock:nil];
    
    else if([self isDeleted])
        [self removeRemotely:nil errorBlock:nil];
    
    else
        [self get:nil completionBlock:nil errorBlock:nil];
}

- (void) sync:(CKRequest *) request parseBlock:(CKParseBlock) parseBlock completionBlock:(CKResultBlock) completionBlock errorBlock:(CKResultBlock) errorBlock{
    
    if(request.parseBlock == nil)
        request.parseBlock = parseBlock;
    
    if(request.completionBlock == nil)
        request.completionBlock = completionBlock;
    
    if(request.errorBlock == nil)
        request.errorBlock = errorBlock;    
}


- (id) serialize{
    
    return [[CKManager sharedManager] serialize:self];
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
    
    if([sortedBy length] > 0)
        [request setSortDescriptors:CK_SORT(sortedBy)];
    
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
    
    return [self aggregateForKeyPath:[NSString stringWithFormat:@"@min.%@", attribute]];
}

+ (NSNumber *) maximum:(NSString *)attribute{
    
    return [self aggregateForKeyPath:[NSString stringWithFormat:@"@max.%@", attribute]];
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
    
    NSString *fixturePath = CKPathForBundleResource([NSBundle bundleForClass:[self class]], ckFixturePath);

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
#pragma mark Value Formatting
- (id) stringValueForKeyPath:(NSString *) keyPath{
    
    id value = [self valueForKeyPath:keyPath];
    NSString *stringValue = [NSString string];
    
    if([value isKindOfClass:[NSString class]])
        stringValue = value;
    
    else if ([value isKindOfClass:[NSNumber class]]){
        
        NSNumberFormatter *formatter = [self numberFormatter];
        
        NSAttributeDescription *description = (NSAttributeDescription *) [self propertyDescriptionForKey:keyPath];
        
        switch ([description attributeType]) {
            
            default:
                break;
                
            case NSFloatAttributeType:
            case NSDecimalAttributeType:
            case NSDoubleAttributeType:
                [formatter setMaximumFractionDigits:2];
                break;
        }
        
        stringValue = [formatter stringFromNumber:value];
    }
    
    else if([value isKindOfClass:[NSDate class]]){
        
        stringValue = [[self dateFormatter] stringFromDate:value];
    }
     
    return stringValue;
}

- (NSDateFormatter *) dateFormatter{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [CKManager sharedManager].dateFormat;
    
    if([formatter.dateFormat length] == 0)
        [formatter setDateFormat:[[self class] dateFormat]];
    
    return formatter;
}

- (NSNumberFormatter *) numberFormatter{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    return formatter;
}

#pragma mark -
#pragma mark Seeds

+ (BOOL) seed{
    
    return [self seedGroup:nil];
}

+ (BOOL) seedGroup:(NSString *) groupName{
    
    NSArray *files = [CKManager seedFiles];
    NSArray *seeds = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH %@", [self entityNameWithPrefix:YES]]];
    return [[CKManager sharedManager] loadSeedFiles:seeds groupName:groupName];
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
