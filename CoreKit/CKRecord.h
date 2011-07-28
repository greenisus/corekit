//
//  CKRecord.h
//  CoreKit
//
//  Created by Matt Newberry on 7/19/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRequest.h"
#import "CKResult.h"
#import "CKSupport.h"

@class CKSearch;

/** Options used for default settings */ 
typedef enum CKRecordOptions {
    CKRecordOptionsSaveAutomatically,
    CKRecordOptionsOverrideRelationships,
    CKRecordOptionsConvertCamelCase,
    CKRecordOptionsPrimaryKeyName,
    CKRecordOptionsClassPrefix,
    CKRecordOptionsDateFormat
} CKRecordOptions;

@interface CKRecord : NSManagedObject {
    
    NSDictionary *_attributes;
}


/** @name Entity Methods */

/** Cached property list */
@property (nonatomic, readonly) NSDictionary *attributes;

/** Return the name of the model */
+ (NSString *) entityName;
/** Return the name of the model and optionally remove the class prefix (if there is one) 
 
 @param removePrefix Optionally remove the class prefix
 */
+ (NSString *) entityNameWithPrefix: (BOOL) removePrefix;

/** Return the entity description */
+ (NSEntityDescription *) entityDescription;

/** Default fetch request for entity */
+ (NSFetchRequest *) fetchRequest;


/** @name Saving */
/** Save changes to object 

 Convience method mapped to class CKCoreData method [CKCoreData save]
 */
+ (BOOL) save;

/** Save changes to object 
 
 Convience method mapped to class CKCoreData method [CKCoreData save]
 */
- (BOOL) save;

/** @name Creating, Updating, Deleting */

/** Create a blank record */
+ (id) blank;

/** Automatically create or update a resource 
 If a record exists matching the passed data parameter, update: is called. If not, create: is called.
 @param data NSDictionary or NSArray containing data to populate record with
 */
+ (id) build:(id) data;

/** Create a new record
 If an array is passed, the method will call itself for each value
 @param data NSDictionary or NSArray containing data to populate record with
 */
+ (id) create:(id) data;

/** Update an existing record
 @param data Key/values to update the record with
 */
- (id) update:(NSDictionary *) data;

/** Update all matching records with the specified data 
 @param predicate query to match records by
 @param data data to update matching records with
 */
+ (void) updateWithPredicate:(NSPredicate *) predicate withData:(NSDictionary *) data;

/** Remove an existing record
 */
- (void) remove;

/** Remove all of the entity's records
 */
+ (void) removeAll;

/** Remove all of the entity's records that match the specified predicate
 @param predicate `NSPredicate` object
 */
+ (void) removeAllWithPredicate:(NSPredicate *) predicate;


/** @name Remote */




/** @name Counting */

/** Count all of an entities records */
+ (NSUInteger) count;

/** Count all of an entities records that match the specified predicate
 @param predicate `NSPredicate` object
 */
+ (NSUInteger) countWithPredicate:(NSPredicate *) predicate;

/** @name Searching */

/** Return the first record using the default sort method */
+ (id) first;
/** Return the last record using the default sort method */
+ (id) last;
/** Check to see if a record exists using it's ID
 @param itemID Primary key
 */
+ (BOOL) exists:(NSNumber *) itemID;

/** Return all records using the default sort method */
+ (NSArray *) all;
/** Return all records using the specified sort method 
 @param sortBy Sort syntax
 */
+ (NSArray *) allSortedBy:(NSString *) sortBy;

/** Return all records using a predfined class CKSearch object 
 @param search 
 */ 
// + (NSArray *) find:(CKSearch *) search;

/** Find all results matching the specified predicate 
 @param predicate `NSPredicate` object
 */
+ (NSArray *) findWithPredicate:(NSPredicate *) predicate;
/** Find all results matching the specified predicate with a specific sort by and limit 
 @param predicate `NSPredicate` object
 @param sortBy Sort syntax
 @param limit Maximum number of records to return
 */
+ (NSArray *) findWithPredicate:(NSPredicate *) predicate sortedBy:(NSString *) sortedBy withLimit:(NSUInteger) limit;
/** Find all results where the specified attribute is exactly the value 
 @param attribute Attribute to search by
 @param value value to match for the attribute
 */
+ (NSArray *) findWhereAttribute:(NSString *) attribute equals:(id) value;
/** Find all results where the specified attribute contains the value 
 @param attribute Attribute to search by
 @param value value to check against
 */
+ (NSArray *) findWhereAttribute:(NSString *) attribute contains:(id) value;

/** Find a record by a specified ID
 @param itemId the ID of the object
 */
+ (id) findById:(NSNumber *) itemId;

/** @name Aggregates */
/** Average the specified attribute 
 Attribute must be of NSNumber type
 @param attribute the attribute to average
 */
+ (NSNumber *) average:(NSString *) attribute;
/** Find the minimum value of the specified attribute 
 Attribute must be of NSNumber type
 @param attribute the attribute to find the minimum value of
 */
+ (NSNumber *) minimum:(NSString *) attribute;
/** Find the maximum value of the specified attribute 
 Attribute must be of NSNumber type
 @param attribute the attribute to find the maximum value of
 */
+ (NSNumber *) maximum:(NSString *) attribute;
/** Find the sum of the specified attribute 
 Attribute must be of NSNumber type
 @param attribute the attribute to sum
 */
+ (NSNumber *) sum:(NSString *) attribute;



/** @name Fixtures */

/** Load all fixtures for class
 
 By default, this method uses the class name to infer a file path. For example, if the model name is Orders, the file path will be inferred as `fixtures/Orders.*` (the file type is not necessary). 
 */
+ (id) fixtures;

/** Returns all fixtures as an array, minus their keys (used for batch creation) */
+ (NSArray *) fixturesAsArray;

/** Return a fixture by name
 
 As with  fixtures, the file path is inferred, and only the fixture within that file will be returned.  This assumes that the fixture file contains a Hash data structure that will be parsed into an NSDictionary.
 
 @param name The name of the key of the fixture to return
 */
+ (id) fixtureNamed:(NSString *) name;

/** Return a fixture based upon a name and relative file path
 
 @param name As with method fixtures, the file path is inferred, and only the fixture within that file will be returned. 
 @param path The relative file path for the fixture to load 
 */
+ (id) fixtureNamed:(NSString *) name atPath:(NSString *) path;


/** @name Defaults */

/** Default date format string for NSDate conversions */
+ (NSString *) dateFormat;

/** Dictionary containing keys consisting of local fields with objects representing remote fields they should be mapped to */
+ (NSDictionary *) attributeMap;

/** Primary key field name */
+ (NSString *) primaryKeyName;


@end
