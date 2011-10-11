//
//  CKTableViewDataSource.m
//  CoreKit
//
//  Created by Matt Newberry on 9/20/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKTableViewDataSource.h"

@implementation CKTableViewDataSource

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize tableView = _tableView;
@synthesize entityDescription = _entityDescription;
@synthesize cellClass = _cellClass;

- (id)init {
    self = [super init];
    if (self) {
        if ([self respondsToSelector:@selector(entityClass)]) {
            Class entityClass = [self performSelector:@selector(entityClass)];
            self.entityDescription = [entityClass performSelector:@selector(entityDescription)];
        }
    }
    return self;
}

+ (id) dataSourceForEntity:(NSString *) entity andTableView:(UITableView *) tableView{
    
    CKTableViewDataSource *dataSource = [[[self class] alloc] init];

    dataSource.tableView = tableView;
    
    Class model = NSClassFromString(entity);
    dataSource.entityDescription = [model entityDescription];
    
    return dataSource;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCellStyle)tableViewCellStyle {
    
    return UITableViewCellStyleDefault;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        Class tableViewCellClass = _cellClass == nil ? [UITableViewCell class] : _cellClass;
        cell = [[tableViewCellClass alloc] initWithStyle:[self tableViewCellStyle] reuseIdentifier:CellIdentifier];
    }
    
    CKRecord *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath withObject:managedObject];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id) object{
    
    // Override
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath withObject:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
}

- (NSFetchedResultsController *) fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    Class model = NSClassFromString([_entityDescription managedObjectClassName]);
    NSFetchRequest *fetchRequest = [model fetchRequest];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[CKManager sharedManager].managedObjectContext sectionNameKeyPath:nil cacheName:_entityDescription.managedObjectClassName];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

@end
