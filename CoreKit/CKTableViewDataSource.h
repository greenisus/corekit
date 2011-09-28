//
//  CKTableViewDataSource.h
//  CoreKit
//
//  Created by Matt Newberry on 9/20/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CKManager.h"

@interface CKTableViewDataSource : NSObject <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/** The table view for the data source.  It is optionally an IBOutlet so you can set it in a
 *  nib or storyboard.  If you do this, your CKTableViewDataSource subclass should implement
 *  a -(Class)entityClass method that returns the entity class that this data source
 *  represents.
 */
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSEntityDescription *entityDescription;
@property (nonatomic, assign) Class cellClass;

+ (id) dataSourceForEntity:(NSString *) entity andTableView:(UITableView *) tableView;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id) object;

@end
