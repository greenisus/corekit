//
//  TwitterSearchTableViewController.m
//  TwitterExample
//
//  Created by Matt Newberry on 8/15/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "TwitterSearchTableViewController.h"
#import "Tweet.h"
#import "TweetCell.h"

@implementation TwitterSearchTableViewController
@synthesize tweets = _tweets;
@synthesize loadingView = _loadingView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _tweets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc{
    
    [super dealloc];
    [_tweets release];
    _tweets = nil;
    [_loadingView release];
    _loadingView = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Search Twitter";

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.delegate = self;
    searchBar.text = @"Rackspace";
    self.tableView.tableHeaderView = searchBar;
    [searchBar release];
        
     _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     _loadingView.frame = CGRectMake((self.view.frame.size.width / 2) - _loadingView.frame.size.width/2, (self.view.frame.size.height / 2) - _loadingView.frame.size.height/2 + 10, _loadingView.frame.size.width, _loadingView.frame.size.height);
    _loadingView.hidesWhenStopped = YES;
    [self.view addSubview:_loadingView];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self searchBarSearchButtonClicked:(UISearchBar *) self.tableView.tableHeaderView];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [_loadingView startAnimating];
    [_tweets removeAllObjects];
    [self.tableView reloadData];
    
    [Tweet search:searchBar.text parseBlock:nil completionBlock:^(CKResult *result){
        
        for(id obj in result){
            
            Tweet *tweet = [Tweet build:obj];
            [_tweets addObject:tweet];
        };
        
        [self.tableView reloadData];
        [_loadingView stopAnimating];
            
    } errorBlock:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_tweets count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    
    TweetCell *cell = (TweetCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options: nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    Tweet *tweet = [_tweets objectAtIndex:indexPath.section];
    cell.userName.text = tweet.from_user;
    
    cell.tweet.text = tweet.text;
    CGSize size = [tweet.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    cell.tweet.frame = CGRectMake(cell.tweet.frame.origin.x, cell.tweet.frame.origin.y, cell.tweet.frame.size.width, size.height);
    
    NSTimeInterval interval = abs([tweet.created_at timeIntervalSinceNow]);
    
    if(interval <= 60)
        cell.time.text = [NSString stringWithFormat:@"%is",(int)interval];
    else{
        int mins = (int)(interval / 60);
        cell.time.text = [NSString stringWithFormat:@"%im",mins];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Tweet *tweet = [_tweets objectAtIndex:indexPath.section];
    
    CGSize size = [tweet.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    return size.height + 40;
}

@end
