//
//  TweetCell.h
//  TwitterExample
//
//  Created by Matt Newberry on 8/15/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell{
    
    IBOutlet UILabel *_userName;
    IBOutlet UILabel *_tweet;
    IBOutlet UILabel *_time;
}

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *tweet;
@property (nonatomic, strong) UILabel *time;

@end
