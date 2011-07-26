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

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectContext*) newManagedObjectContext;
- (NSString *) storePath;
- (NSURL *) storeURL;
- (NSDictionary *) persistentStoreOptions;
- (BOOL) save;

#if NS_BLOCKS_AVAILABLE
- (void)performBlock:(void (^)())block NS_AVAILABLE(10_7,  5_0);
- (void)performBlockAndWait:(void (^)())block NS_AVAILABLE(10_7,  5_0);
#endif


@end
