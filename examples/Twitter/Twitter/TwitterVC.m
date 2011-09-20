//
//  TwitterVC.m
//  Twitter
//
//  Created by Matt Newberry on 9/16/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "TwitterVC.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TwitterVCDataSource.h"

@implementation TwitterVC

@synthesize loadingView = _loadingView;
@synthesize dataSource = _dataSource;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    _dataSource = [[TwitterVCDataSource alloc] init];
    _dataSource.tableView = self.tableView;
    _dataSource.entityDescription = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:[CKManager sharedManager].managedObjectContext];
    _dataSource.cellClass = [TweetCell class];
    
    self.tableView.dataSource = _dataSource;
    self.tableView.delegate = self;
    self.title = @"Search Twitter";
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.delegate = self;
    searchBar.text = @"Rackspace";
    self.tableView.tableHeaderView = searchBar;
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadingView.frame = CGRectMake((self.view.frame.size.width / 2) - _loadingView.frame.size.width/2, (self.view.frame.size.height / 2) - _loadingView.frame.size.height/2 + 10, _loadingView.frame.size.width, _loadingView.frame.size.height);
    _loadingView.hidesWhenStopped = YES;
    
    [self.view addSubview:_loadingView];
        
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self searchBarSearchButtonClicked:(UISearchBar *) self.tableView.tableHeaderView];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
          
    [searchBar resignFirstResponder];
    [_loadingView startAnimating];
    [Tweet removeAll];
        
    [Tweet search:searchBar.text parseBlock:nil completionBlock:^(CKResult *result){
                
        [_loadingView stopAnimating];
        
    } errorBlock:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Tweet *tweet = [_dataSource.fetchedResultsController objectAtIndexPath:indexPath];
    
    CGSize size = [tweet.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    return size.height + 40;
}


@end
