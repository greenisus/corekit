//
//  CKCoreData.h
//  CoreKit
//
//  Created by Matt Newberry on 7/15/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKCoreData : NSObject{
    
    NSManagedObjectContext *_managedObjectContext;
	NSManagedObjectModel *_managedObjectModel;
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectContext*) newManagedObjectContext;
- (NSString *) storePath;
- (NSURL *) storeURL;
- (NSString *) persistentStoreType;
- (NSDictionary *) persistentStoreOptions;
- (BOOL) save;
- (NSString *) applicationDocumentsDirectory;

@end
