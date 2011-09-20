//
//  TwitterVC.h
//  Twitter
//
//  Created by Matt Newberry on 9/16/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitterVCDataSource;

@interface TwitterVC : UITableViewController<UISearchBarDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) TwitterVCDataSource *dataSource;

@end
