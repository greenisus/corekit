//
//  TwitterVC.h
//  Twitter
//
//  Created by Matt Newberry on 9/16/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterVC : UITableViewController<UISearchBarDelegate>{
    
    NSMutableArray *_tweets;
    UIActivityIndicatorView *_loadingView;
}

@property (nonatomic, retain) NSMutableArray *tweets;
@property (nonatomic, retain) UIActivityIndicatorView *loadingView;

@end
