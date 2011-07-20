//
//  CKRecord.h
//  CoreKit
//
//  Created by Matt Newberry on 7/19/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRequest.h"

@interface CKRecord : NSManagedObject {
    
}

/** @name Entity Methods */

/** Return the name of the model */
+ (NSString *) entityName;
/** Return the name of the model and optionally remove the class prefix (if there is one) 
 
 @param removePrefix Optionally remove the class prefix
 */
+ (NSString *) entityNameWithPrefix: (BOOL) removePrefix;

/** Return the entity description */
+ (NSEntityDescription *) entityDescription;

/** Return the default managed object context */
+ (NSManagedObjectContext *) managedObjectContext;


/** @name Creating, Updating, Deleting */

/** Create a blank record */
+ (id) blank;


/** @name Fixtures */

/** Load all fixtures for class
 
 By default, this method uses the class name to infer a file path. For example, if the model name is Orders, the file path will be inferred as `fixtures/Orders.*` (the file type is not necessary). 
 */
+ (id) fixtures;

/** Return a fixture by name
 
    As with method fixtures, the file path is inferred, and only the fixture within that file will be returned.  This assumes that the fixture file contains a Hash data structure that will be parsed into an NSDictionary.
 
 @param name The name of the key of the fixture to return
 */
+ (id) fixtureByName:(NSString *) name;

/** Return a fixture based upon a name and relative file path
 
 @param name As with method fixtures, the file path is inferred, and only the fixture within that file will be returned. 
 
 @param path The relative file path for the fixture to load 
 */
+ (id) fixtureByName:(NSString *) name atPath:(NSString *) path;

@end
