//
//  TwitterSearchTableViewController.h
//  TwitterExample
//
//  Created by Matt Newberry on 8/15/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterSearchTableViewController : UITableViewController <UISearchBarDelegate>{
    
    NSMutableArray *_tweets;
    UIActivityIndicatorView *_loadingView;
}

@property (nonatomic, retain) NSMutableArray *tweets;
@property (nonatomic, retain) UIActivityIndicatorView *loadingView;

@end
