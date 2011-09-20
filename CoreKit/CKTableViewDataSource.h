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

@interface CKTableViewDataSource : NSObject <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    NSFetchedResultsController *_fetchedResultsController;
    UITableView *_tableView;
    
    NSEntityDescription *_entityDescription;
    
    Class _cellClass;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSEntityDescription *entityDescription;
@property (nonatomic, assign) Class cellClass;

+ (id) dataSourceForEntity:(NSString *) entity andTableView:(UITableView *) tableView;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id) object;

@end
