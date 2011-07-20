//
//  CKCoreData.m
//  CoreKit
//
//  Created by Matt Newberry on 7/15/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKCoreData.h"

#ifndef __IPHONE_5_0
#import "NSThread+Blocks.m"
#else
#import <UIKit/UIKit.h>
#endif

@implementation CKCoreData

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#define ckCoreDataApplicationStorageType		NSSQLiteStoreType
#define ckCoreDataTestingStorageType            NSInMemoryStoreType
#define ckCoreDataStoreFileName                 @"CoreDataStore.sqlite"
#define ckCoreDataThreadKey                     @"ckCoreDataThreadKey"


- (id)init{
    
    if (self = [super init]){
        
//#ifdef __IPHONE_5_0  
//        UIManagedDocument *doc = [[UIManagedDocument alloc] initWithFileURL:[self storeURL]];
//        doc.persistentStoreOptions = [self persistentStoreOptions];
//        
//        [doc openWithCompletionHandler:^(BOOL success){
//            if (!success) {
//                NSLog(@"****************** FAILED TO OPEN **********************");
//            }
//        }];
//        
//        self.managedObjectContext = doc.managedObjectContext; 
//        self.managedObjectModel = doc.managedObjectModel;
//#else
        self.managedObjectModel = [self managedObjectModel];
		self.persistentStoreCoordinator = [self persistentStoreCoordinator];
		_managedObjectContext = [self newManagedObjectContext];
//#endif
    }
    
    return self;
}

#if NS_BLOCKS_AVAILABLE
- (void)performBlock:(void (^)())block{
    
#ifdef __IPHONE_5_0
    [_managedObjectContext performBlock:block];
#else
    [[NSThread currentThread] performBlockInBackground:block];
#endif
}

- (void)performBlockAndWait:(void (^)())block{
    
#ifdef __IPHONE_5_0
    [_managedObjectContext performBlockAndWait:block];
#else
    [[NSThread currentThread] performBlock:block waitUntilDone:YES];
#endif
}

#endif

- (NSManagedObjectContext *) managedObjectContext{
    
    if (([NSThread isMainThread] && _managedObjectContext != nil) || _managedObjectContext != nil)
		return _managedObjectContext;
    else {
		
		NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
		NSManagedObjectContext *backgroundThreadContext = [threadDictionary objectForKey:ckCoreDataThreadKey];
		
		if (!backgroundThreadContext) {
			
			backgroundThreadContext = [self newManagedObjectContext];					
			[threadDictionary setObject:backgroundThreadContext forKey:ckCoreDataThreadKey];			
			[backgroundThreadContext release];
		}
        
		return backgroundThreadContext;
	}
}

- (NSManagedObjectContext*) newManagedObjectContext{
	
	NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
	[moc setPersistentStoreCoordinator:self.persistentStoreCoordinator];
	[moc setUndoManager:nil];
	[moc setMergePolicy:NSOverwriteMergePolicy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:moc];
    
	return moc;
}

- (NSManagedObjectModel *) managedObjectModel{
    
    if( _managedObjectModel != nil)
		return _managedObjectModel;
    
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]]]; 
    
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator{
    
	if( _persistentStoreCoordinator != nil)
		return _persistentStoreCoordinator;
	
	NSString* storePath = [self storePath];    
    NSURL *storeURL = [self storeURL];
    
    NSError* error;
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
	
	NSDictionary* options = [self persistentStoreOptions];
	
    NSLog(@"Delegate = %@", [[UIApplication sharedApplication] delegate]);
    if (![_persistentStoreCoordinator addPersistentStoreWithType:ckCoreDataApplicationStorageType configuration:nil URL:storeURL options:options error:&error]){
        
		[[NSFileManager defaultManager] removeItemAtPath:storePath error:nil];
		
		if (![_persistentStoreCoordinator addPersistentStoreWithType:ckCoreDataApplicationStorageType configuration:nil URL:storeURL options:options error:&error]){
            
            // Something is terribly wrong
            abort();
        }
	}
	
	return _persistentStoreCoordinator;
}

- (NSDictionary *) persistentStoreOptions{
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,nil];
}

- (void) managedObjectContextDidSave:(NSNotification *)notification{
    
	[self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
												withObject:notification
											 waitUntilDone:YES];
}

- (NSString *) storePath{
    
    return [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingPathComponent:ckCoreDataStoreFileName];
}

- (NSURL *) storeURL{
    
    return [NSURL fileURLWithPath:[self storePath]];
}

- (void) dealloc{
    
    [_managedObjectModel release];
    [_managedObjectContext release];
    [_persistentStoreCoordinator release];
    
    [super dealloc];
}

@end
